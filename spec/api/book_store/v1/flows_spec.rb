require 'rails_helper'

describe 'endpoints' do
  context 'flow endpoints' do
    context 'get' do
      let(:flow_endpoint) { '/api/v1/flows/flows' }

      context 'when there is one flow' do
        let!(:flow) { create(:flow) }

        it 'does return a 200' do
          get flow_endpoint
          expect(response.status).to eq 200
        end

        it 'returns a list of 1 book' do
          get flow_endpoint
          expect(JSON.parse(response.body)[0]['id']).to be Flow.first.id
          expect(Flow.all.count).to be 1
        end
      end

      context 'when there are multiple flows' do
        let!(:flow_1) { create(:flow) }
        let!(:flow_2) { create(:flow) }
        let!(:flow_3) { create(:flow) }

        it 'returns a 200' do
          get flow_endpoint
          expect(response.status).to eq 200
        end

        it 'returns a list of 1 flow' do
          get flow_endpoint
          expect(JSON.parse(response.body)[0]['id']).to be flow_1.id
          expect(JSON.parse(response.body)[1]['id']).to be flow_2.id
          expect(JSON.parse(response.body)[2]['id']).to be flow_3.id
          expect(Flow.all.count).to be 3
        end
      end
    end

    context 'post' do
      let(:flow_endpoint) { '/api/v1/flows/flow' }

      let(:previous_stock) { Faker::Number.number(digits: 4) }
      let(:new_stock) { Faker::Number.number(digits: 4) }
      let!(:book) { create(:book) }

      context 'when there are no flows in the database' do
        it 'creates a book in the database' do
          post flow_endpoint, :params => { book: book.id, previousStock: previous_stock, newStock: new_stock }


          expect(Flow.all.count).to eq 1
          expect(Flow.first.previousStock).to eq previous_stock
          expect(Flow.first.newStock).to eq new_stock
          expect(Flow.first.book_id).to eq book.id
        end
      end

      context 'when there are flows in the database' do
        let!(:flow_1) { create(:flow) }
        let!(:flow_2) { create(:flow) }
        let!(:flow_3) { create(:flow) }

        it 'creates a flow in the database' do
          post flow_endpoint, :params => { book: book.id, previousStock: previous_stock, newStock: new_stock }

          expect(Flow.all.count).to eq 4
          expect(Flow.all.fourth.previousStock).to be previous_stock
          expect(Flow.all.fourth.newStock).to be new_stock
          expect(Flow.all.fourth.book_id).to be book.id
        end
      end
    end

    context 'put' do
      let(:flow_endpoint) { '/api/v1/flows/:id' }

      context 'with one flow in the database' do
        let!(:flow) { create(:flow) }
        let!(:new_stock) { flow.newStock+2 }
        let!(:previous_stock) { flow.previousStock+2 }

        it 'updates the newStock of a specified flow' do
          put flow_endpoint, :params => { flow: { id: flow.id, newStock: new_stock }}

          expect(Flow.all.count).to be 1
          expect(Flow.first.id).to eq flow.id
          expect(Flow.first.newStock).to eq new_stock
          expect(Flow.first.previousStock).to eq flow.previousStock
        end

        it 'updates the previousStock of a specified flow' do
          put flow_endpoint, :params => { flow: { id: flow.id, previousStock: previous_stock }}

          expect(Flow.count).to be 1
          expect(Flow.first.previousStock).to eq previous_stock
          expect(Flow.first.newStock).to eq flow.newStock
          expect(Flow.first.newStock).not_to eq new_stock
        end

        it 'updates the newStock and previousStock of a specified flow' do
          put flow_endpoint, :params => {  flow: { id: flow.id, newStock: new_stock, previousStock: previous_stock }}

          expect(Flow.count).to be 1
          expect(Flow.first.newStock).to eq new_stock
          expect(Flow.first.newStock).not_to eq flow.newStock
          expect(Flow.first.previousStock).to eq previous_stock
          expect(Flow.first.previousStock).not_to eq flow.previousStock
        end
      end

      context 'with multiple flows in the database' do
        let!(:flow) { create(:flow) }
        let!(:extra_flow_1) { create(:flow) }
        let!(:extra_flow_2) { create(:flow) }
        let!(:extra_flow_3) { create(:flow) }
        let(:new_stock) { flow.newStock+2 }
        let(:previous_stock) { flow.previousStock+2 }

        it 'updates the newStock of a specified flow' do
          put flow_endpoint, :params => { flow: { id: flow.id, newStock: new_stock }}

          expect(Flow.count).to be 4
          expect(Flow.first.id).to eq flow.id
          expect(Flow.first.newStock).not_to eq flow.newStock
        end

        it 'updates the previousStock of a specified flow' do
          put flow_endpoint, :params => { flow: { id: flow.id, previousStock: previous_stock }}

          expect(Flow.all.count).to be 4
          expect(Flow.first.id).to eq flow.id
          expect(Flow.first.previousStock).to eq previous_stock
          expect(Flow.first.previousStock).not_to eq flow.previousStock
        end

        it 'updates the newStock and previousStock of a specified flow' do
          put flow_endpoint, :params => {  flow: { id: flow.id, newStock: new_stock, previousStock: previous_stock }}

          expect(Flow.all.count).to be 4
          expect(Flow.first.id).to eq flow.id
          expect(Flow.first.newStock).to eq new_stock
          expect(Flow.first.newStock).not_to eq flow.newStock
          expect(Flow.first.previousStock).to eq previous_stock
          expect(Flow.first.previousStock).not_to eq flow.previousStock
        end
      end
    end

    context 'delete' do
      let(:flow_endpoint) { '/api/v1/flows/:id' }

      context 'when there is one flow' do
        let(:flow) { create(:flow) }

        it 'deletes a flow' do
          delete flow_endpoint, :params => { flow: { id: flow.id }}

          expect(Flow.count).to be 0
        end
      end

      context 'when there are multiple flows' do
        let!(:flow_1) { create(:flow) }
        let!(:flow_2) { create(:flow) }
        let!(:flow_3) { create(:flow) }

        it 'deletes the first flow' do
          delete flow_endpoint, :params => { flow: { id: flow_1.id }}

          expect(Flow.count).to be 2
          expect(Flow.first).to eq flow_2
          expect(Flow.second).to eq flow_3
        end

        it 'deletes the second flow' do
          delete flow_endpoint, :params => { flow: { id: flow_2.id }}

          expect(Flow.count).to be 2
          expect(Flow.first).to eq flow_1
          expect(Flow.second).to eq flow_3
        end

        it 'deletes the third flow' do
          delete flow_endpoint, :params => { flow: { id: flow_3.id }}

          expect(Flow.count).to be 2
          expect(Flow.first).to eq flow_1
          expect(Flow.second).to eq flow_2
        end
      end
    end
  end
end