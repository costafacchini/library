# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::DashboardControllerPolicy, type: :policy do
  subject(:dashboard) { described_class }

  let(:user) { build(:user) }

  permissions :index? do
    it 'grants access' do
      expect(dashboard).to permit user
    end
  end
end
