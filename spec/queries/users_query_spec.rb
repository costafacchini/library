# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersQuery do
  describe '#call' do
    subject(:users_query) { described_class.new }

    it 'returns a list of users' do
      member1 = create(:user, :member)
      member2 = create(:user, :member, email: 'john@doe.com')
      librarian = create(:user, :librarian, email: 'mary@jane.com')

      results = users_query.call
      expect(results).to eq [member1, member2, librarian]
    end

    it 'returns the members list sorted by #id' do
      member1 = create(:user, :member, id: 20)
      member2 = create(:user, :member, email: 'john@doe.com', id: 10)
      member3 = create(:user, :member, email: 'mary@jane.com', id: 30)

      results = users_query.call
      expect(results).to eq [member2, member1, member3]
    end
  end

  describe '#with_overdue' do
    it 'prepares #call to result a list of users with overdue books' do
      member1 = create(:user, :member)
      member2 = create(:user, :member, email: 'john@doe.com')
      member3 = create(:user, :member, email: 'johnjr@doe.com')
      member4 = create(:user, :member, email: 'mary@jane.com')

      create(:borrow, member: member1, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27),
                      returned_at: nil)
      create(:borrow, member: member2, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27),
                      returned_at: nil)
      create(:borrow, member: member3, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27),
                      returned_at: Date.new(2024, 5, 8))
      create(:borrow, member: member4, borrowed_at: Date.new(2024, 6, 14), due_date: Date.new(2024, 6, 28),
                      returned_at: nil)

      result = described_class.new.with_overdue(Date.new(2024, 6, 27)).call

      expect(result).not_to include [member3, member4]
      expect(result).to eq [member1, member2]
    end
  end
end
