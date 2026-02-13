class InsuranceClaim < ApplicationRecord
  include AASM

  belongs_to :customer, class_name: "Customer", inverse_of: :insurance_claims
  belongs_to :request, optional: true

  has_many_attached :supporting_documents

  validates :applicant_name, :applicant_phone, :incident_address,
            :incident_date, :incident_description, presence: true
  validates :claim_number, uniqueness: true

  before_create :generate_claim_number

  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }

  aasm column: :status, whiny_transitions: true do
    state :draft, initial: true
    state :submitted
    state :under_review
    state :approved
    state :rejected
    state :completed

    event :submit_claim do
      before { self.submitted_at = Time.current }
      transitions from: :draft, to: :submitted
    end

    event :start_review do
      transitions from: :submitted, to: :under_review
    end

    event :approve do
      before { self.reviewed_at = Time.current }
      transitions from: :under_review, to: :approved
    end

    event :reject do
      before { self.reviewed_at = Time.current }
      transitions from: :under_review, to: :rejected
    end

    event :complete do
      before { self.completed_at = Time.current }
      transitions from: :approved, to: :completed
    end
  end

  def status_label
    { "draft" => "작성 중", "submitted" => "신청 완료",
      "under_review" => "심사 중", "approved" => "승인",
      "rejected" => "반려", "completed" => "완료" }[status] || status
  end

  def damage_type_label
    { "property_damage" => "재산 피해", "personal_injury" => "인적 피해",
      "both" => "재산 + 인적 피해" }[damage_type] || "-"
  end

  def prefill_from_request!
    return unless request.present?
    self.incident_address ||= request.address
    self.incident_detail_address ||= request.detailed_address
    self.incident_description ||= request.description
    self.applicant_name ||= customer.name
    self.applicant_phone ||= customer.phone
    self.applicant_email ||= customer.email
  end

  private

  def generate_claim_number
    self.claim_number = "INS-#{Time.current.strftime('%Y%m')}-#{SecureRandom.hex(4).upcase}"
  end
end
