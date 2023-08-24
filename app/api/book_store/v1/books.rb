module BookStore
  module V1
    class Books < Grape::API
      version 'v1'
      format 'json'
      prefix :api

      resource :books do
        desc 'returns list of books'
        get :books do
          Book.all
        end

        desc 'create a book'
        params do
          requires :isbn, type: Integer, desc: 'International Standard Book Number'
          requires :title, type: String, desc: 'title of the book'
          requires :stock, type: Integer, desc: 'how many books are in stock'
        end
        post :book do
          Book.create!({
                         isbn: params[:isbn],
                         title: params[:title],
                         stock: params[:stock]
                       })
        end

        desc 'update a book'
        params do
          requires :id, type: String, desc: 'book id'
          optional :isbn, type: Integer, desc: 'International Standard Book Number'
          optional :title, type: String, desc: 'title of the book'
          optional :stock, type: Integer, desc: 'how many books are in stock'
        end
        put ':id' do
          Book.find(params[:book][:id]).update!({
                                          isbn: params[:book][:isbn],
                                          title: params[:book][:title],
                                          stock: params[:book][:stock]
                                        })
        end

        desc 'delete a book'
        params do
          requires :id, type: String, desc: 'book id'
        end
        delete ':id' do
          Book.find(params[:book][:id]).delete
        end
      end
    end
  end
end
