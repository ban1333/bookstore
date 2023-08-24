require 'rails_helper'

describe 'endpoints' do
  context 'books endpoints' do
    context 'get' do
      let(:book_endpoint) { '/api/v1/books/books' }
      context 'when there is one book' do
        let(:book) { create(:book) }

        it 'does return a 200' do
          get book_endpoint
          expect(response.status).to eq 200
        end

        it 'returns a list of 1 book' do
          get book_endpoint
          expect(JSON.parse(response.body)[0]['id']).to be Book.first.id
          expect(Book.all.count).to be 1
        end
      end

      context 'when there are multiple books' do
        let!(:book_1) { create(:book) }
        let!(:book_2) { create(:book) }
        let!(:book_3) { create(:book) }

        it 'does return a 200' do
          get book_endpoint
          expect(response.status).to eq 200
        end

        it 'returns a list of 1 book' do
          get book_endpoint
          expect(JSON.parse(response.body)[0]['id']).to be book_1.id
          expect(JSON.parse(response.body)[1]['id']).to be book_2.id
          expect(JSON.parse(response.body)[2]['id']).to be book_3.id
          expect(Book.all.count).to be 1
        end
      end
    end

    context 'post' do
      let(:book_endpoint) { '/api/v1/books/book' }

      let(:isbn) { Faker::Number.number(digits: 4) }
      let(:title) { Faker::Superhero.power }
      let(:stock) { Faker::Number.between(from: 2, to: 19) }

      context 'when there are no books in the database' do
        it 'creates a book in the database' do
          post book_endpoint, :params => { isbn: isbn, title: title, stock: stock }

          expect(Book.all.count).to eq 1
          expect(Book.first.isbn).to eq isbn
        end
      end

      context 'when there are books in the database' do
        let!(:book_1) { create(:book) }
        let!(:book_2) { create(:book) }
        let!(:book_3) { create(:book) }

        it 'creates a book in the database' do
          post book_endpoint, :params => { isbn: isbn, title: title, stock: stock }

          expect(Book.all.count).to eq 4
          # TODO: refactor this so it's more robust
          expect(Book.all.fourth.isbn).to be isbn
        end
      end
    end

    context 'put' do
      let(:book_endpoint) { '/api/v1/books/:id' }

      context 'with one book in the database' do
        let!(:book) { create(:book) }
        let(:book_id) { book.id }
        let(:new_isbn) { book.isbn+2 }
        let(:new_title) { book.title+'ahhh' }
        let(:new_stock) { book.stock+2 }

        it 'updates the stock of a specified book' do
          put book_endpoint, :params => { book: { id: book_id, stock: new_stock }}

          expect(Book.all.count).to be 1
          expect(Book.first.id).to eq book_id
          expect(Book.first.stock).not_to eq book.stock
        end

        it 'updates the title of a specified book' do
          put book_endpoint, :params => { book: { id: book_id, title: new_title }}

          expect(Book.all.count).to be 1
          expect(Book.first.id).to eq book_id
          expect(Book.first.title).not_to eq book.title
        end

        it 'updates the isbn of a specified book' do
          put book_endpoint, :params => { book: { id: book_id, isbn: new_isbn }}

          expect(Book.all.count).to be 1
          expect(Book.first.id).to eq book_id
          expect(Book.first.isbn).not_to eq book.isbn
        end

        it 'updates the isbn, title and stock of a specified book' do
          put book_endpoint, :params => {  book: { id: book_id, isbn: new_isbn, title: new_title, stock: new_stock }}

          expect(Book.all.count).to be 1
          expect(Book.first.id).to eq book_id
          expect(Book.first.isbn).not_to eq book.isbn
          expect(Book.first.title).not_to eq book.title
          expect(Book.first.stock).not_to eq book.stock
        end
      end

      context 'with multiple books in the database' do
        let!(:book) { create(:book) }
        let!(:extra_book_1) { create(:book) }
        let!(:extra_book_2) { create(:book) }
        let!(:extra_book_3) { create(:book) }
        let(:book_id) { book.id }
        let(:new_isbn) { book.isbn+2 }
        let(:new_title) { book.title+'ahhh' }
        let(:new_stock) { book.stock+2 }

        it 'updates the stock of a specified book' do
          put book_endpoint, :params => { book: { id: book_id, stock: new_stock }}

          expect(Book.all.count).to be 4
          expect(Book.first.id).to eq book_id
          expect(Book.first.stock).not_to eq book.stock
        end

        it 'updates the title of a specified book' do
          put book_endpoint, :params => { book: { id: book_id, title: new_title }}

          expect(Book.all.count).to be 4
          expect(Book.first.id).to eq book_id
          expect(Book.first.title).not_to eq book.title
        end

        it 'updates the isbn of a specified book' do
          put book_endpoint, :params => { book: { id: book_id, isbn: new_isbn }}

          expect(Book.all.count).to be 4
          expect(Book.first.id).to eq book_id
          expect(Book.first.isbn).not_to eq book.isbn
        end

        it 'updates the isbn, title and stock of a specified book' do
          put book_endpoint, :params => {  book: { id: book_id, isbn: new_isbn, title: new_title, stock: new_stock }}

          expect(Book.all.count).to be 4
          expect(Book.first.id).to eq book_id
          expect(Book.first.isbn).not_to eq book.isbn
          expect(Book.first.title).not_to eq book.title
          expect(Book.first.stock).not_to eq book.stock
        end
      end
    end

    context 'delete' do
      let(:book_endpoint) { '/api/v1/books/:id' }

      context 'when there is one book' do
        let(:book) { create(:book) }

        it 'deletes a book' do
          delete book_endpoint, :params => { book: { id: book.id }}

          expect(Book.count).to be 0
        end
      end

      context 'when there are multiple books' do
        let!(:book_1) { create(:book) }
        let!(:book_2) { create(:book) }
        let!(:book_3) { create(:book) }

        it 'deletes the first book' do
          delete book_endpoint, :params => { book: { id: book_1.id }}

          expect(Book.count).to be 2
          expect(Book.first.id).to be book_2.id
          expect(Book.second.id).to be book_3.id
        end

        it 'deletes the second book' do
          delete book_endpoint, :params => { book: { id: book_2.id }}

          expect(Book.count).to be 2
          expect(Book.first.id).to be book_1.id
          expect(Book.second.id).to be book_3.id
        end

        it 'deletes the third book' do
          delete book_endpoint, :params => { book: { id: book_3.id }}

          expect(Book.count).to be 2
          expect(Book.first.id).to be book_1.id
          expect(Book.second.id).to be book_2.id
        end
      end
    end
  end
end
