require 'rails_helper'

RSpec.describe UsersQuery do
  describe '#call' do
    it 'returns a list of users' do
      member1 = create(:user, :member)
      member2 = create(:user, :member, email: 'john@doe.com')
      librarian = create(:user, :librarian, email: 'mary@jane.com')

      results = subject.call
      expect(results).to eq [member1, member2, librarian]
    end

    it 'returns the members list sorted by #id' do
      member1 = create(:user, :member, id: 20)
      member2 = create(:user, :member, email: 'john@doe.com', id: 10)
      member3 = create(:user, :member, email: 'mary@jane.com', id: 30)

      results = subject.call
      expect(results).to eq [member2, member1, member3]
    end
  end

  describe '#with_overdue' do
    it 'prepares #call to result a list of users with overdue books' do
      member1 = create(:user, :member)
      member2 = create(:user, :member, email: 'john@doe.com')
      member3 = create(:user, :member, email: 'johnjr@doe.com')
      member4 = create(:user, :member, email: 'mary@jane.com')

      book1 = create(:book, title: 'Book 1')
      book2 = create(:book, title: 'Book 2')
      book3 = create(:book, title: 'Book 3')
      book4 = create(:book, title: 'Book 4')

      create(:borrow, member: member1, book: book1, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27), returned_at: nil)
      create(:borrow, member: member2, book: book2, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27), returned_at: nil)
      create(:borrow, member: member3, book: book3, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27), returned_at: Date.new(2024, 5, 8))
      create(:borrow, member: member4, book: book4, borrowed_at: Date.new(2024, 6, 14), due_date: Date.new(2024, 6, 28), returned_at: nil)

      query = described_class.new
      result = query.with_overdue(Date.new(2024, 6, 27)).call

      expect(result).not_to include member3
      expect(result).not_to include member4
      expect(result).to eq [member1, member2]
    end

    it 'returns self' do
      query = described_class.new
      expect(query.with_overdue(nil)).to eq query
    end
  end
end
