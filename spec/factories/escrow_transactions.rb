FactoryBot.define do
  factory :escrow_transaction do
    association :request
    association :customer
    association :master, factory: [:master, :verified]
    amount { 220_000 }
    payment_method { "card" }
  end
end
