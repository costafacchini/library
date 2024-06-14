require 'rails_helper'

RSpec.describe Dashboard::Librarian, type: :model do
  describe '#total' do
    it 'returns the total of books in the library' do
      librarian = create(:user, :librarian)

      create(:book, title: 'Book 1')
      create(:book, title: 'Book 2')
      create(:book, title: 'Book 3')

      subject = described_class.new
      subject.load(librarian, Date.new(2024, 6, 27))

      expect(subject.total).to eql 3
    end
  end

  describe '#total_borrowed' do
    it 'returns the total of books borrowed in the library' do
      member = create(:user, :member)

      book1 = create(:book, title: 'Book 1')
      book2 = create(:book, title: 'Book 2')
      book3 = create(:book, title: 'Book 3')
      book4 = create(:book, title: 'Book 4')

      create(:borrow, member:, book: book1, borrowed_at: Date.new(2024, 6, 13), returned_at: nil)
      create(:borrow, member:, book: book2, borrowed_at: Date.new(2024, 6, 13), returned_at: nil)
      create(:borrow, member:, book: book3, borrowed_at: Date.new(2024, 6, 13), returned_at: Date.new(2024, 5, 8))
      create(:borrow, member:, book: book4, borrowed_at: Date.new(2024, 6, 14), returned_at: nil)

      subject = described_class.new

      librarian = create(:user, :librarian, email: 'john@doe.com')
      subject.load(librarian, Date.new(2024, 6, 27))

      expect(subject.total_borrowed).to eql 3
    end
  end

  describe '#due_today' do
    it 'returns a list of books that due today' do
      member = create(:user, :member)

      book1 = create(:book, title: 'Book 1')
      book2 = create(:book, title: 'Book 2')
      book3 = create(:book, title: 'Book 3')
      book4 = create(:book, title: 'Book 4')

      create(:borrow, member:, book: book1, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27), returned_at: nil)
      create(:borrow, member:, book: book2, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27), returned_at: nil)
      create(:borrow, member:, book: book3, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27), returned_at: Date.new(2024, 5, 8))
      create(:borrow, member:, book: book4, borrowed_at: Date.new(2024, 6, 14), due_date: Date.new(2024, 6, 28), returned_at: nil)

      subject = described_class.new

      librarian = create(:user, :librarian, email: 'john@doe.com')
      subject.load(librarian, Date.new(2024, 6, 28))

      expect(subject.due_today.size).to eql 1
      expect(subject.due_today[0].id).to eql book4.id
      expect(subject.due_today[0].title).to eql 'Book 4'
      expect(subject.due_today[0].due_date).to eql Date.new(2024, 6, 28)
    end
  end

  describe '#members_overdue' do
    it 'returns a list of members with their books overdue' do
      member1 = create(:user, :member, name: 'Member 1')
      member2 = create(:user, :member, email: 'john@doe.com')
      member3 = create(:user, :member, email: 'johnjr@doe.com')

      book1 = create(:book, title: 'Book 1')
      book2 = create(:book, title: 'Book 2')
      book3 = create(:book, title: 'Book 3')
      book4 = create(:book, title: 'Book 4')

      create(:borrow, member: member1, book: book1, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27), returned_at: nil)
      create(:borrow, member: member2, book: book2, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27), returned_at: nil)
      create(:borrow, member: member3, book: book3, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27), returned_at: Date.new(2024, 5, 8))
      create(:borrow, member: member1, book: book4, borrowed_at: Date.new(2024, 6, 14), due_date: Date.new(2024, 6, 28), returned_at: nil)

      subject = described_class.new

      librarian = create(:user, :librarian, email: 'librarian@doe.com')
      subject.load(librarian, Date.new(2024, 6, 27))

      expect(subject.members_overdue.size).to eql 2
      expect(subject.members_overdue[0].id).to eql member1.id
      expect(subject.members_overdue[0].name).to eql 'Member 1'
      expect(subject.members_overdue[0].books.size).to eql 1
      expect(subject.members_overdue[0].books[0].id).to eql book1.id
      expect(subject.members_overdue[0].books[0].title).to eql 'Book 1'
      expect(subject.members_overdue[0].books[0].due_date).to eql Date.new(2024, 6, 27)
    end
  end

  describe '#attributes' do
    it 'returns all attributes to serialize' do
      subject = described_class.new

      expect(subject.attributes).to include 'total'
      expect(subject.attributes).to include 'total_borrowed'
      expect(subject.attributes).to include 'due_today'
      expect(subject.attributes).to include 'members_overdue'
    end
  end
end
