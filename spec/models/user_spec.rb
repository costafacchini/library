require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
  end

  describe '#borrows' do
    it { is_expected.to have_many(:borrows).dependent(:destroy).with_foreign_key(:member_id) }
  end

  it { should define_enum_for(:role).with_values([:librarian, :member]) }
end
