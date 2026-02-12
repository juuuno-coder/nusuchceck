require "rails_helper"

RSpec.describe EscrowTransaction, type: :model do
  describe "validations" do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should belong_to(:request) }
    it { should belong_to(:customer) }
    it { should belong_to(:master) }
  end

  describe "AASM" do
    let(:escrow) { create(:escrow_transaction) }

    it "starts with pending status" do
      expect(escrow).to be_pending
    end

    it "transitions to deposited" do
      escrow.deposit!
      expect(escrow).to be_deposited
      expect(escrow.deposited_at).to be_present
    end

    it "transitions to released from deposited" do
      escrow.deposit!
      escrow.release!
      expect(escrow).to be_released
    end

    it "transitions to settled from released" do
      escrow.deposit!
      escrow.release!
      escrow.settle!
      expect(escrow).to be_settled
    end

    it "can refund from deposited" do
      escrow.deposit!
      escrow.refund!
      expect(escrow).to be_refunded
    end
  end

  describe "fee calculation" do
    let(:escrow) { create(:escrow_transaction, amount: 1_000_000) }

    it "calculates platform fee at 5%" do
      expect(escrow.fee_amount).to eq(50_000)
    end

    it "calculates master payout" do
      expect(escrow.payout_amount).to eq(950_000)
    end

    it "saves calculated fees" do
      escrow.save!
      expect(escrow.platform_fee).to eq(50_000)
      expect(escrow.master_payout).to eq(950_000)
    end
  end
end
