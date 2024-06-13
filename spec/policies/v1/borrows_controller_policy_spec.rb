require 'rails_helper'

RSpec.describe V1::BorrowsControllerPolicy, type: :policy do
  let(:user) { build(:user) }

  subject { described_class }

  permissions :create? do
    it 'grants access' do
      expect(subject).to permit user
    end
  end
end
