require 'rails_helper'

RSpec.describe Dashboard, type: :model do
  describe '#data' do
    it 'returns an instance of dashboard by role' do
      user = create(:user, :member)

      expect(described_class.new(user, nil).data).to be_an_instance_of Dashboard::Member
    end
  end
end
