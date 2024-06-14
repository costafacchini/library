# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dashboard::Factory do
  describe '.create' do
    context 'when user is a member' do
      it 'returns a instance of Dashboard::Member' do
        user = build(:user, :member)

        expect(described_class.create(user)).to be_an_instance_of Dashboard::Member
      end
    end

    context 'when is a librarian role' do
      it 'returns a instance of Invoice::CompressWrapper::Canceled' do
        user = build(:user, :librarian)

        expect(described_class.create(user)).to be_an_instance_of Dashboard::Librarian
      end
    end
  end
end
