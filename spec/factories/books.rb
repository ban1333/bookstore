FactoryBot.define do
  factory :book do
    isbn { Faker::Number.number(digits: 4) }
    title  { Faker::Superhero.unique.power }
    stock { Faker::Number.between(from: 2, to: 19) }
  end
end
