# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::BorrowsControllerPolicy, type: :policy do
  subject(:borow) { described_class }

  let(:user) { build(:user) }

  permissions :create? do
    it 'grants access' do
      expect(borow).to permit user
    end
  end

  context 'when the user is librarian' do
    let(:user) { build_stubbed(:user, role: :librarian) }

    permissions :update? do
      it 'grants access' do
        expect(borow).to permit user
      end
    end
  end

  context 'when the user is member' do
    let(:user) { build_stubbed(:user, role: :member) }

    permissions :update? do
      it 'denies access' do
        expect(borow).not_to permit user
      end
    end
  end
end
