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
          requires :id, type: Integer, desc: 'book id'
          optional :isbn, type: Integer, desc: 'International Standard Book Number'
          optional :title, type: String, desc: 'title of the book'
          optional :stock, type: Integer, desc: 'how many books are in stock'
        end
        put ':id' do
          Book.find(params[:id]).update({
                                          isbn: params[:isbn],
                                          title: params[:title],
                                          stock: params[:stock]
                                        })
        end
      end
    end
  end
end
