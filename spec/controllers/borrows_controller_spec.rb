require 'rails_helper'
require_relative 'shared_samples_for_authorization'

RSpec.describe V1::BorrowsController, type: :controller do
  it_behaves_like 'is authenticable', :borrow, only: [:create, :update]

  let(:current_user) { create(:user, role: :librarian) }

  describe 'POST /create' do
    before { sign_in current_user }
    after { sign_out current_user }

    context 'when the borrow is valid' do
      it 'returns success' do
        book = create(:book)

        post :create, params: { borrow: { book_id: book.id, borrowed_at: Date.new(2024, 6, 13).iso8601 } }

        expect(response).to have_http_status(:created)
        expect(response.body).to include('2024-06-13')
      end
    end

    context 'when the borrow is invalid' do
      it 'returns unprocessable entity' do
        post :create, params: { borrow: { book_id: 98998 } }

        expect(response).to have_http_status(422)
        expect(response.body).to include('message', "Borrowed at can't be blank", "Book must exist")
      end
    end
  end

  describe 'PATCH /update' do
    before { sign_in current_user }
    after { sign_out current_user }

    it 'returns success' do
      borrow = create(:borrow, member: current_user, returned_at: nil)

      patch :update, params: { id: borrow, borrow: { returned_at: Date.new(2024, 6, 13).iso8601 } }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Book returned successfully')
    end
  end
end
