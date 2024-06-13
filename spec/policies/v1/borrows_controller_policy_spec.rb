require 'rails_helper'

RSpec.describe V1::BorrowsControllerPolicy, type: :policy do
  let(:user) { build(:user) }

  subject { described_class }

  permissions :create? do
    it 'grants access' do
      expect(subject).to permit user
    end
  end

  context 'when the user is librarian' do
    let(:user) { build_stubbed(:user, role: :librarian) }

    permissions :update? do
      it 'grants access' do
        expect(subject).to permit user
      end
    end
  end

  context 'when the user is member' do
    let(:user) { build_stubbed(:user, role: :member) }

    permissions :update? do
      it 'denies access' do
        expect(subject).not_to permit user
      end
    end
  end
end
