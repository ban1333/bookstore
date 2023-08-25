module BookStore
  module V1
    class Flows < Grape::API
      version 'v1'
      format 'json'
      prefix :api

      resource :flows do
        desc 'returns a list of flows'
        get :flows do
          Flow.all
        end

        desc 'create a flow'
        # need params here
        post :flow do

          Flow.create!({
                         book: book,
                         previousStock: previousStock,
                         nextStock: nextStock
                       })
        end
      end
    end
  end
end
