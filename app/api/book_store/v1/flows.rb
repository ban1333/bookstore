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
        params do
          requires :book, type: String, desc: 'the id of the book'
          requires :previousStock, type: Integer, desc: 'the previous stock'
          requires :newStock, type: Integer, desc: 'the next stock'
        end
        post :flow do

          Flow.create!({
                         book: Book.find(params[:book]),
                         previousStock: params[:previousStock],
                         newStock: params[:newStock]
                       })
        end
      end
    end
  end
end
