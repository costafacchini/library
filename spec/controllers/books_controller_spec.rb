require 'rails_helper'
require_relative 'shared_samples_for_authorization'

RSpec.describe V1::BooksController, type: :controller do
  it_behaves_like 'is authenticable', :book

  let(:current_user) { create(:user) }

  describe 'GET /index' do
    before { sign_in current_user }
    after { sign_out current_user }

    it 'returns success' do
      create(:book, title: 'To Kill a Mockingbird', author: 'Harper Lee', genre: 'Novel', isbn: '9780061120084',
            total_copies: 40_000_000)
      create(:book, title: 'Ikigai: The Japanese Secret to a Long and Happy Life', author: 'Héctor García',
            genre: 'Personal Development', isbn: '9788543108946', total_copies: 100_000_000)

      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eql(2)
      expect(response.body).to include('To Kill a Mockingbird')
      expect(response.body).to include('Ikigai: The Japanese Secret to a Long and Happy Life')
    end
  end

  describe 'GET /show' do
    before { sign_in current_user }
    after { sign_out current_user }

    it 'returns success' do
      book = create(:book, title: 'To Kill a Mockingbird')

      get :show, params: { id: book }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('To Kill a Mockingbird')
    end

    it 'returns not found when book does not exists' do
      get :show, params: { id: 99_999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /create' do
    before { sign_in current_user }
    after { sign_out current_user }

    context 'when the book is valid' do
      it 'returns success' do
        post :create, params: { book: { title: 'To Kill a Mockingbird', author: 'Harper Lee', genre: 'Novel' } }

        expect(response).to have_http_status(:created)
        expect(response.body).to include('To Kill a Mockingbird')
      end
    end

    context 'when the book is invalid' do
      it 'returns unprocessable entity' do
        post :create, params: { book: { genre: 'Novel' } }

        expect(response).to have_http_status(422)
        expect(response.body).to include('message', "Title can't be blank", "Author can't be blank")
      end
    end
  end

  describe 'PATCH /update' do
    before { sign_in current_user }
    after { sign_out current_user }

    context 'when the book is valid' do
      it 'returns success' do
        book = create(:book, title: 'To Kill a Mockingbird')

        patch :update, params: { id: book, book: { title: 'Updated' } }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Updated')
      end
    end

    context 'when the book is invalid' do
      it 'returns unprocessable entity' do
        book = create(:book, title: 'To Kill a Mockingbird')

        patch :update, params: { id: book, book: { title: nil } }

        expect(response).to have_http_status(422)
        expect(response.body).to include('message', "Title can't be blank")
      end
    end
  end

  describe 'DELETE /destroy' do
    before { sign_in current_user }
    after { sign_out current_user }

    it 'returns no content' do
      book = create(:book)

      delete :destroy, params: { id: book.id }

      expect(response).to have_http_status(:no_content)
    end
  end
end
