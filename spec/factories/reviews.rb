FactoryBot.define do
  factory :review do
    association :request
    association :customer
    association :master, factory: [:master, :verified]
    punctuality_rating { 4 }
    skill_rating { 5 }
    kindness_rating { 4 }
    cleanliness_rating { 4 }
    price_rating { 3 }
    comment { "좋은 서비스였습니다." }
  end
end
