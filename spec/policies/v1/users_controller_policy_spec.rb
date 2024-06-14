# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::UsersControllerPolicy, type: :policy do
  subject(:controller) { described_class }

  context 'when the user is librarian' do
    let(:user) { build_stubbed(:user, role: :librarian) }

    permissions :index?, :update? do
      it 'grants access' do
        expect(controller).to permit user
      end
    end

    it 'returns the role as a permitted attribute' do
      expect(controller.new(user, nil).permitted_attributes).to be :role
    end
  end

  context 'when the user is member' do
    let(:user) { build_stubbed(:user, role: :member) }

    permissions :index?, :update? do
      it 'denies access' do
        expect(controller).not_to permit user
      end
    end

    it 'returns blank as a permitted attribute' do
      expect(controller.new(user, nil).permitted_attributes).to be_nil
    end
  end
end
