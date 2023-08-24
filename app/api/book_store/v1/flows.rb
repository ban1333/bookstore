module BookStore
  module V1
    class Flows < Grape::API
      version 'v1'
      format 'json'
      prefix :api

      resource :flows do

      end
    end
  end
end
