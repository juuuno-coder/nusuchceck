require "rails_helper"

RSpec.describe EscrowService do
  let(:customer) { create(:customer) }
  let(:master) { create(:master, :verified) }
  let(:request) { create(:request, customer: customer, master: master) }

  describe "#create_and_deposit!" do
    let(:service) { described_class.new(request) }

    it "creates an escrow transaction and deposits" do
      escrow = service.create_and_deposit!(amount: 500_000)

      expect(escrow).to be_deposited
      expect(escrow.amount).to eq(500_000)
      expect(escrow.customer).to eq(customer)
      expect(escrow.master).to eq(master)
      expect(escrow.pg_transaction_id).to be_present
    end

    it "calculates fees correctly" do
      escrow = service.create_and_deposit!(amount: 1_000_000)

      expect(escrow.platform_fee).to eq(50_000)
      expect(escrow.master_payout).to eq(950_000)
    end
  end

  describe "#release!" do
    let(:service) { described_class.new(request) }

    before do
      service.create_and_deposit!(amount: 500_000)
    end

    it "releases and settles the escrow" do
      service.release!
      escrow = request.escrow_transaction.reload

      expect(escrow).to be_settled
      expect(escrow.released_at).to be_present
    end
  end

  describe "#refund!" do
    let(:service) { described_class.new(request) }

    before do
      service.create_and_deposit!(amount: 500_000)
    end

    it "refunds the escrow" do
      service.refund!
      escrow = request.escrow_transaction.reload

      expect(escrow).to be_refunded
      expect(escrow.refunded_at).to be_present
    end
  end
end
