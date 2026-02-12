FactoryBot.define do
  factory :estimate do
    association :request
    association :master, factory: [:master, :verified]
    line_items do
      [
        { category: "trip", name: "기본 출장비", unit: "건", quantity: 1, unit_price: 50_000, amount: 50_000 },
        { category: "detection", name: "청음 탐지", unit: "건", quantity: 1, unit_price: 150_000, amount: 150_000 }
      ]
    end
    notes { "견적 비고" }
    valid_until { 7.days.from_now }
  end
end
