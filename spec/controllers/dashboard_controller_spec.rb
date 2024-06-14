require 'rails_helper'
require_relative 'shared_samples_for_authorization'

RSpec.describe V1::DashboardController, type: :controller do
  it_behaves_like 'is authenticable', :dashboard, only: [:index]

  let(:current_user) { create(:user, role: :librarian) }

  describe 'GET /index' do
    before { sign_in current_user }
    after { sign_out current_user }

    it 'returns success' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('total')
    end
  end
end
