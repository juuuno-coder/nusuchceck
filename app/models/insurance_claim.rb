class InsuranceClaim < ApplicationRecord
  include AASM

  belongs_to :customer, class_name: "Customer", inverse_of: :insurance_claims
  belongs_to :request, optional: true
  belongs_to :prepared_by_master, class_name: "Master", optional: true

  has_many_attached :supporting_documents

  validates :applicant_name, :applicant_phone, :incident_address,
            :incident_date, :incident_description, presence: true
  validates :claim_number, uniqueness: true

  before_create :generate_claim_number

  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }

  aasm column: :status, whiny_transitions: true do
    state :draft, initial: true
    state :pending_customer_review  # 마스터가 작성 후 고객 검토 대기
    state :submitted
    state :under_review
    state :approved
    state :rejected
    state :completed

    # 고객이 직접 제출
    event :submit_claim do
      before { self.submitted_at = Time.current }
      transitions from: :draft, to: :submitted
    end

    # 마스터가 작성 완료 → 고객 검토 대기
    event :send_to_customer do
      transitions from: :draft, to: :pending_customer_review
    end

    # 고객이 승인 → 제출
    event :customer_approve do
      before do
        self.customer_reviewed = true
        self.customer_reviewed_at = Time.current
        self.submitted_at = Time.current
      end
      transitions from: :pending_customer_review, to: :submitted
    end

    # 고객이 수정 요청 → 다시 draft로
    event :customer_request_changes do
      transitions from: :pending_customer_review, to: :draft
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
    { "draft" => "작성 중",
      "pending_customer_review" => "고객 확인 대기",
      "submitted" => "신청 완료",
      "under_review" => "심사 중",
      "approved" => "승인",
      "rejected" => "반려",
      "completed" => "완료" }[status] || status
  end

  def prepared_by_master?
    prepared_by_master_id.present?
  end

  def pending_customer_approval?
    pending_customer_review? && prepared_by_master?
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

    # 마스터가 작성할 때 견적 정보 가져오기
    if prepared_by_master? && request.accepted_estimate.present?
      estimate = request.accepted_estimate
      self.estimated_damage_amount ||= estimate.total_amount
    end
  end

  private

  def generate_claim_number
    self.claim_number = "INS-#{Time.current.strftime('%Y%m')}-#{SecureRandom.hex(4).upcase}"
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id status claim_number customer_id request_id applicant_name insurance_company created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[customer request prepared_by_master]
  end
end
