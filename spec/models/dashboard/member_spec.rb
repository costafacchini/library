require 'rails_helper'

RSpec.describe Dashboard::Member, type: :model do
  describe '#my_books' do
    it 'returns books still borrowed to member' do
      member = create(:user, :member)
      another_member = create(:user, :member, email: 'john@doe.com')

      book1 = create(:book, title: 'Book 1')
      book2 = create(:book, title: 'Book 2')
      book3 = create(:book, title: 'Book 3')

      create(:borrow, member:, book: book1, borrowed_at: Date.new(2024, 5, 10), returned_at: nil)
      create(:borrow, member: another_member, book: book2, borrowed_at: Date.new(2024, 5, 11), returned_at: nil)
      create(:borrow, member:, book: book3, borrowed_at: Date.new(2024, 5, 12), returned_at: Date.new(2024, 6, 13))

      subject = described_class.new
      subject.load(member, Date.new(2024, 6, 27))

      expect(subject.my_books.size).to eql 1
      expect(subject.my_books[0].id).to eql book1.id
      expect(subject.my_books[0].title).to eql 'Book 1'
      expect(subject.my_books[0].borrowed_at).to eql Date.new(2024, 5, 10)
      expect(subject.my_books[0].due_date).to eql Date.new(2024, 5, 24)
    end
  end

  describe '#overdue' do
    it 'returns books overdue to member' do
      member = create(:user, :member)
      another_member = create(:user, :member, email: 'john@doe.com')

      book1 = create(:book, title: 'Book 1')
      book2 = create(:book, title: 'Book 2')
      book3 = create(:book, title: 'Book 3')
      book4 = create(:book, title: 'Book 4')

      create(:borrow, member:, book: book1, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27), returned_at: nil)
      create(:borrow, member: another_member, book: book2, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27), returned_at: nil)
      create(:borrow, member:, book: book3, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27), returned_at: Date.new(2024, 5, 8))
      create(:borrow, member:, book: book4, borrowed_at: Date.new(2024, 6, 14), due_date: Date.new(2024, 6, 28), returned_at: nil)

      subject = described_class.new
      subject.load(member, Date.new(2024, 6, 27))

      expect(subject.overdue.size).to eql 1
      expect(subject.overdue[0].id).to eql book1.id
      expect(subject.overdue[0].title).to eql 'Book 1'
      expect(subject.overdue[0].due_date).to eql Date.new(2024, 6, 27)
    end
  end

  describe '#attributes' do
    it 'returns all attributes to serialize' do
      subject = described_class.new

      expect(subject.attributes).to include 'my_books'
      expect(subject.attributes).to include 'overdue'
    end
  end
end
