class Request < ApplicationRecord
  include AASM

  belongs_to :customer, class_name: "Customer", inverse_of: :requests
  belongs_to :master, class_name: "Master", optional: true, inverse_of: :assigned_requests
  has_many :estimates, dependent: :destroy
  has_one :escrow_transaction, dependent: :destroy
  has_one :review, dependent: :destroy
  has_many :insurance_claims, dependent: :nullify
  has_many_attached :photos

  validates :symptom_type, presence: true
  validates :address, presence: true
  validates :customer, presence: true

  enum :symptom_type, {
    wall_leak: 0,
    ceiling_leak: 1,
    floor_leak: 2,
    pipe_leak: 3,
    toilet_leak: 4,
    outdoor_leak: 5
  }

  enum :building_type, {
    apartment: 0,
    villa: 1,
    house: 2,
    office: 3,
    store: 4,
    factory: 5,
    other_building: 6
  }

  enum :detection_result, {
    result_pending: 0,
    leak_confirmed: 1,
    no_leak: 2,
    inconclusive: 3
  }, prefix: :detection

  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.address_changed? }

  scope :active, -> { where.not(status: [:closed, :cancelled]) }
  scope :by_status, ->(status) { where(status: status) }
  scope :recent, -> { order(created_at: :desc) }
  scope :for_master, ->(master) { where(master: master) }

  # AASM State Machine - 13 states, 15+ transitions
  aasm column: :status, whiny_transitions: true do
    state :reported, initial: true
    state :assigned
    state :visiting
    state :detecting
    state :no_leak_found
    state :estimate_pending
    state :estimate_submitted
    state :construction_agreed
    state :escrow_deposited
    state :constructing
    state :construction_completed
    state :closed
    state :cancelled

    # 마스터 배정
    event :assign do
      before do |master:|
        self.master = master
        self.assigned_at = Time.current
      end
      transitions from: :reported, to: :assigned, guard: :master_present?
    end

    # 방문 시작
    event :visit do
      before { self.visit_started_at = Time.current }
      transitions from: :assigned, to: :visiting
    end

    # 현장 도착 → 탐지 시작
    event :arrive do
      before { self.detection_started_at = Time.current }
      transitions from: :visiting, to: :detecting
    end

    # 탐지 완료 (누수 확인)
    event :detection_complete do
      transitions from: :detecting, to: :estimate_pending,
                  guard: :leak_confirmed?
    end

    # 탐지 실패 (누수 미확인)
    event :detection_fail do
      before { self.detection_result = :no_leak }
      transitions from: :detecting, to: :no_leak_found
    end

    # 견적 제출
    event :submit_estimate do
      transitions from: :estimate_pending, to: :estimate_submitted,
                  guard: :has_estimates?
    end

    # 견적 수락
    event :accept_estimate do
      transitions from: :estimate_submitted, to: :construction_agreed
    end

    # 에스크로 입금
    event :deposit_escrow do
      transitions from: :construction_agreed, to: :escrow_deposited,
                  guard: :escrow_deposited_check?
    end

    # 공사 시작
    event :start_construction do
      before { self.construction_started_at = Time.current }
      transitions from: :escrow_deposited, to: :constructing
    end

    # 공사 완료
    event :complete_construction do
      before { self.construction_completed_at = Time.current }
      transitions from: :constructing, to: :construction_completed
    end

    # 고객 완료 확인 → 대금 지급
    event :confirm_completion do
      transitions from: :construction_completed, to: :closed,
                  after: :release_escrow_payment
    end

    # 누수 미확인 종료 (비용 미청구)
    event :close_no_charge do
      before { self.closed_at = Time.current }
      transitions from: :no_leak_found, to: :closed
    end

    # 최종 종료 (관리자)
    event :finalize do
      before { self.closed_at = Time.current }
      transitions from: [:construction_completed], to: :closed
    end

    # 취소 (공사 진행 전 단계에서만 가능)
    event :cancel do
      before { self.closed_at = Time.current }
      transitions from: [:reported, :assigned, :visiting, :detecting,
                         :no_leak_found, :estimate_pending, :estimate_submitted,
                         :construction_agreed],
                  to: :cancelled
    end
  end

  def accepted_estimate
    estimates.find_by(status: "accepted")
  end

  def calculate_total_fee
    self.total_fee = trip_fee.to_d + detection_fee.to_d + construction_fee.to_d
  end

  def can_be_reviewed?
    closed? && review.nil?
  end

  def status_label
    I18n.t("activerecord.enums.request.status.#{status}", default: status.humanize)
  end

  private

  def master_present?
    master.present?
  end

  def leak_confirmed?
    detection_leak_confirmed?
  end

  def has_estimates?
    estimates.exists?
  end

  def escrow_deposited_check?
    escrow_transaction&.deposited?
  end

  def release_escrow_payment
    self.closed_at = Time.current
    EscrowService.new(escrow_transaction).release! if escrow_transaction&.deposited?
  end
end
