require 'rails_helper'

RSpec.describe V1::BooksControllerPolicy, type: :policy do
  let(:user) { build(:user) }

  subject { described_class }

  permissions :show?, :index? do
    it 'grants access' do
      expect(subject).to permit user
    end
  end

  context 'when the user is librarian' do
    let(:user) { build_stubbed(:user, role: :librarian) }

    permissions :create?, :update?, :destroy? do
      it 'grants access' do
        expect(subject).to permit user
      end
    end
  end

  context 'when the user is member' do
    let(:user) { build_stubbed(:user, role: :member) }

    permissions :create?, :update?, :destroy? do
      it 'denies access' do
        expect(subject).not_to permit user
      end
    end
  end
end
