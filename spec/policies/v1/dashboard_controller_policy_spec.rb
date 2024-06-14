require 'rails_helper'

RSpec.describe V1::DashboardControllerPolicy, type: :policy do
  let(:user) { build(:user) }

  subject { described_class }

  permissions :index? do
    it 'grants access' do
      expect(subject).to permit user
    end
  end
end
