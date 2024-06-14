# frozen_string_literal: true

RSpec.shared_examples 'is authenticable' do |model, only: nil|
  only ||= %i[index show create update destroy]

  if only.include? :index
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
  end

  if only.include? :show
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
  end

  if only.include? :create
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
  end

  if only.include? :update
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
  end

  if only.include? :destroy
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
end
