FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    phone { "010-#{rand(1000..9999)}-#{rand(1000..9999)}" }
    address { Faker::Address.full_address }

    factory :customer, class: "Customer" do
      type { "Customer" }
    end

    factory :master, class: "Master" do
      type { "Master" }

      trait :verified do
        after(:create) do |master|
          master.master_profile.update!(
            license_number: "NSD-#{rand(1000..9999)}",
            license_type: "누수탐지전문기사",
            equipment: ["청음기", "열화상카메라"],
            service_areas: ["서울 강남구"],
            experience_years: 5,
            bank_name: "국민은행",
            account_number: "123-456-#{rand(100000..999999)}",
            account_holder: master.name,
            verified: true,
            verified_at: Time.current
          )
        end
      end
    end

    factory :admin_user, class: "Customer" do
      type { "Customer" }
      role { :admin }
    end
  end
end
