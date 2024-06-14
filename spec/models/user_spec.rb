# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe '#borrows' do
    it { is_expected.to have_many(:borrows).dependent(:destroy).with_foreign_key(:member_id) }
  end

  it { is_expected.to define_enum_for(:role).with_values(%i[librarian member]) }
end
