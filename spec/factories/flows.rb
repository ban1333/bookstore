FactoryBot.define do
  factory :flow do |existing_book|
    previousStock { Faker::Number.number(digits: 4) }
    newStock  { Faker::Number.number(digits: 4) }
    book_id { existing_book }
  end

  factory :flow_with_new_book do
    book
    previousStock { Faker::Number.number(digits: 4) }
    newStock  { Faker::Number.number(digits: 4) }
    book_id { book }
  end

  factory :book
end
