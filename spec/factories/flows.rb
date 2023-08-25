FactoryBot.define do
  factory :flow do
    book
    previousStock { Faker::Number.number(digits: 4) }
    newStock  { Faker::Number.number(digits: 4) }
  end

  trait :with_specified_book do |existing_book|
    existing_book
    previousStock { Faker::Number.number(digits: 4) }
    newStock  { Faker::Number.number(digits: 4) }
  end
end
