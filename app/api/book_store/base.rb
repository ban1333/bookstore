module BookStore
  class Base < Grape::API
    mount BookStore::V1::Books
    mount BookStore::V1::Flows
  end
end
