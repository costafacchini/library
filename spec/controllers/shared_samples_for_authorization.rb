RSpec.shared_examples 'is authenticable' do |model|
  describe 'GET #index' do
    context 'when the user does not authenticate' do
      before { get :index, as: :json }

      it 'is expected to respond with status code :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user authenticates' do
      create_user_and_sign_in
      before { get :index, as: :json }

      it 'is expected not to respond with status code :unauthorized' do
        expect(response).not_to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /show' do
    context 'when the user does not authenticate' do
      before { get :show, params: { id: 99_999 } }

      it 'is expected to respond with status code :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user authenticates' do
      create_user_and_sign_in
      before { get :show, params: { id: 99_999 } }

      it 'is expected not to respond with status code :unauthorized' do
        expect(response).not_to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /create' do
    context 'when the user does not authenticate' do
      before { post :create, params: { model => { foo: 'bar' } } }

      it 'is expected to respond with status code :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user authenticates' do
      create_user_and_sign_in
      before { post :create, params: { model => { foo: 'bar' } } }

      it 'is expected not to respond with status code :unauthorized' do
        expect(response).not_to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /update' do
    context 'when the user does not authenticate' do
      before { patch :update, params: { id: 99_999 } }

      it 'is expected to respond with status code :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user authenticates' do
      create_user_and_sign_in
      before { patch :update, params: { id: 99_999 } }

      it 'is expected not to respond with status code :unauthorized' do
        expect(response).not_to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when the user does not authenticate' do
      before { patch :destroy, params: { id: 99_999 } }

      it 'is expected to respond with status code :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user authenticates' do
      create_user_and_sign_in
      before { patch :destroy, params: { id: 99_999 } }

      it 'is expected not to respond with status code :unauthorized' do
        expect(response).not_to have_http_status(:unauthorized)
      end
    end
  end
end
