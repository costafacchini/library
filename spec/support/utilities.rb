# frozen_string_literal: true

def create_user_and_sign_in
  let(:current_user) { create(:user) }
  before { sign_in current_user }
end
