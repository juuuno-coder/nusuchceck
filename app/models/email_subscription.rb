class EmailSubscription < ApplicationRecord
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }

  before_create :set_subscribed_at

  private

  def set_subscribed_at
    self.subscribed_at = Time.current
  end
end
