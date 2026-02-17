class Customer < User
  has_many :requests, foreign_key: :customer_id, dependent: :destroy, inverse_of: :customer
  has_many :reviews, foreign_key: :customer_id, dependent: :destroy, inverse_of: :customer
  has_many :escrow_transactions, foreign_key: :customer_id, dependent: :restrict_with_error, inverse_of: :customer
  has_many :insurance_claims, foreign_key: :customer_id, dependent: :destroy, inverse_of: :customer

  def active_requests
    requests.where.not(status: [:closed, :cancelled])
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name email phone address created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[requests]
  end
end
