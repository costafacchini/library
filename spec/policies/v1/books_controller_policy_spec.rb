# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::BooksControllerPolicy, type: :policy do
  subject(:book) { described_class }

  let(:user) { build(:user) }

  permissions :show?, :index? do
    it 'grants access' do
      expect(book).to permit user
    end
  end

  context 'when the user is librarian' do
    let(:user) { build_stubbed(:user, role: :librarian) }

    permissions :create?, :update?, :destroy? do
      it 'grants access' do
        expect(book).to permit user
      end
    end
  end

  context 'when the user is member' do
    let(:user) { build_stubbed(:user, role: :member) }

    permissions :create?, :update?, :destroy? do
      it 'denies access' do
        expect(book).not_to permit user
      end
    end
  end
end
