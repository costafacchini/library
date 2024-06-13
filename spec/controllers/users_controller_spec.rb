require 'rails_helper'
require_relative 'shared_samples_for_authorization'

RSpec.describe V1::UsersController, type: :controller do
  it_behaves_like 'is authenticable', :user, only: [:index, :update]

  let(:current_user) { create(:user, role: :librarian) }

  describe 'GET /index' do
    before { sign_in current_user }
    after { sign_out current_user }

    it 'returns success' do
      create(:user, name: 'John', email: 'john@doe.com')
      create(:user, name: 'Mary', email: 'mary@jane.com')

      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eql(3)
      expect(response.body).to include('John')
      expect(response.body).to include('Mary')
    end
  end

  describe 'PATCH /update' do
    before { sign_in current_user }
    after { sign_out current_user }

    it 'returns success' do
      user = create(:user, role: :member, email: 'john@doe.com')

      patch :update, params: { id: user, user: { role: :librarian } }

      expect(response).to have_http_status(:ok)
    end
  end
end
