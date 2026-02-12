require "rails_helper"

RSpec.describe Request, type: :model do
  let(:customer) { create(:customer) }
  let(:master) { create(:master, :verified) }

  describe "validations" do
    it { should validate_presence_of(:symptom_type) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:customer) }
    it { should belong_to(:customer) }
    it { should belong_to(:master).optional }
    it { should have_many(:estimates) }
  end

  describe "AASM state machine" do
    let(:request) { create(:request, customer: customer) }

    it "starts with reported status" do
      expect(request).to be_reported
    end

    describe "#assign!" do
      it "transitions from reported to assigned" do
        request.assign!(master: master)
        expect(request).to be_assigned
        expect(request.master).to eq(master)
        expect(request.assigned_at).to be_present
      end

      it "fails without a master" do
        expect { request.assign!(master: nil) }.to raise_error(AASM::InvalidTransition)
      end
    end

    describe "#visit!" do
      let(:request) { create(:request, customer: customer) }

      before do
        request.assign!(master: master)
      end

      it "transitions from assigned to visiting" do
        request.visit!
        expect(request).to be_visiting
      end
    end

    describe "#arrive!" do
      let(:request) { create(:request, customer: customer) }

      before do
        request.assign!(master: master)
        request.visit!
      end

      it "transitions from visiting to detecting" do
        request.arrive!
        expect(request).to be_detecting
      end
    end

    describe "#detection_complete!" do
      let(:request) { create(:request, customer: customer) }

      before do
        request.assign!(master: master)
        request.visit!
        request.arrive!
      end

      it "transitions to estimate_pending when leak confirmed" do
        request.update!(detection_result: :leak_confirmed)
        request.detection_complete!
        expect(request).to be_estimate_pending
      end

      it "fails when leak not confirmed" do
        request.update!(detection_result: :no_leak)
        expect { request.detection_complete! }.to raise_error(AASM::InvalidTransition)
      end
    end

    describe "#detection_fail!" do
      let(:request) { create(:request, customer: customer) }

      before do
        request.assign!(master: master)
        request.visit!
        request.arrive!
      end

      it "transitions to no_leak_found" do
        request.detection_fail!
        expect(request).to be_no_leak_found
      end
    end

    describe "#cancel!" do
      it "can cancel from reported" do
        request.cancel!
        expect(request).to be_cancelled
      end

      it "can cancel from assigned" do
        request.assign!(master: master)
        request.cancel!
        expect(request).to be_cancelled
      end

      it "cannot cancel from constructing" do
        request.assign!(master: master)
        request.visit!
        request.arrive!
        request.update!(detection_result: :leak_confirmed)
        request.detection_complete!
        estimate = create(:estimate, request: request, master: master)
        request.submit_estimate!
        request.accept_estimate!
        escrow = request.create_escrow_transaction!(
          customer: customer, master: master,
          amount: estimate.total_amount, payment_method: "card"
        )
        escrow.deposit!
        request.deposit_escrow!
        request.start_construction!

        expect { request.cancel! }.to raise_error(AASM::InvalidTransition)
      end
    end

    describe "full workflow" do
      it "completes the entire happy path" do
        # 1. 신고 접수
        expect(request).to be_reported

        # 2. 마스터 배정
        request.assign!(master: master)
        expect(request).to be_assigned

        # 3. 방문
        request.visit!
        expect(request).to be_visiting

        # 4. 탐지
        request.arrive!
        expect(request).to be_detecting

        # 5. 누수 확인
        request.update!(detection_result: :leak_confirmed)
        request.detection_complete!
        expect(request).to be_estimate_pending

        # 6. 견적 제출
        estimate = create(:estimate, request: request, master: master)
        request.submit_estimate!
        expect(request).to be_estimate_submitted

        # 7. 견적 수락
        request.accept_estimate!
        expect(request).to be_construction_agreed

        # 8. 에스크로 입금
        escrow = request.create_escrow_transaction!(
          customer: customer, master: master,
          amount: estimate.total_amount, payment_method: "card"
        )
        escrow.deposit!
        request.deposit_escrow!
        expect(request).to be_escrow_deposited

        # 9. 공사 시작
        request.start_construction!
        expect(request).to be_constructing

        # 10. 공사 완료
        request.complete_construction!
        expect(request).to be_construction_completed

        # 11. 고객 확인 → 종료
        request.confirm_completion!
        expect(request).to be_closed
      end
    end
  end
end
