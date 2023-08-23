class Book < ApplicationRecord
  has_many :flows

  def with_faker()
    @isbn = Faker::Number.number(digits: 4)
    @title = Faker::Superhero.power
    @stock = Faker::Number.between(from: 2, to: 19)
  end
end
