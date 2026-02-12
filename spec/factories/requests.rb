FactoryBot.define do
  factory :request do
    association :customer
    symptom_type { :wall_leak }
    building_type { :apartment }
    address { "서울시 강남구 테헤란로 123" }
    detailed_address { "아파트 301호" }
    floor_info { "3층" }
    description { "벽면에서 물이 스며들고 있습니다." }
    preferred_date { 3.days.from_now }

    trait :assigned do
      association :master, factory: [:master, :verified]
      status { "assigned" }
      assigned_at { Time.current }
    end

    trait :detecting do
      association :master, factory: [:master, :verified]
      status { "detecting" }
      assigned_at { 2.hours.ago }
      visit_started_at { 1.hour.ago }
      detection_started_at { 30.minutes.ago }
    end

    trait :estimate_pending do
      association :master, factory: [:master, :verified]
      status { "estimate_pending" }
      detection_result { :leak_confirmed }
    end
  end
end
