class Survey < ApplicationRecord
  NEED_APP_OPTIONS = {
    'yes' => '네, 필요합니다',
    'no' => '아니요, 필요하지 않습니다',
    'maybe' => '잘 모르겠습니다'
  }.freeze

  USER_TYPES = {
    'customer' => '고객 (누수 문제가 있는 분)',
    'master' => '전문가 (누수 수리 전문가)',
    'other' => '기타'
  }.freeze

  belongs_to :user, optional: true

  validates :need_app, presence: true, inclusion: { in: NEED_APP_OPTIONS.keys }
  validates :user_type, presence: true, inclusion: { in: USER_TYPES.keys }

  scope :recent, -> { order(created_at: :desc) }
  scope :need_yes, -> { where(need_app: 'yes') }
  scope :need_no, -> { where(need_app: 'no') }
  scope :need_maybe, -> { where(need_app: 'maybe') }

  def self.ransackable_attributes(auth_object = nil)
    %w[id need_app user_type created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
