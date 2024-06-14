# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksQuery do
  subject(:books_query) { described_class.new }

  describe '#call' do
    it 'returns the books list sorted by #title' do
      book_c = create(:book, title: 'c book', id: 20)
      book_b = create(:book, title: 'b book', id: 10)
      book_a = create(:book, title: 'a book', id: 40)

      results = books_query.call
      expect(results).to eq [book_a, book_b, book_c]
    end
  end

  describe '#by_expression' do
    it 'prepares #call to result a list of books filtered by expression' do
      book_a = create(:book, title: 'a book')
      book_b = create(:book, title: 'b book')
      book_ab = create(:book, title: 'ab book')

      result = books_query.by_expression('a').call

      expect(result).not_to include book_b
      expect(result).to eq [book_a, book_ab]
    end
  end

  describe '#still_borrowed_to_member' do
    it 'prepares #call to result a list of books still borrowed to member' do
      member = create(:user, :member)
      another_member = create(:user, :member, email: 'john@doe.com')

      book1 = create(:book, title: 'Book 1')
      book2 = create(:book, title: 'Book 2')
      book3 = create(:book, title: 'Book 3')

      create(:borrow, member:, book: book1, borrowed_at: Date.new(2024, 5, 10), returned_at: nil)
      create(:borrow, member: another_member, book: book2, borrowed_at: Date.new(2024, 5, 11), returned_at: nil)
      create(:borrow, member:, book: book3, borrowed_at: Date.new(2024, 5, 12), returned_at: Date.new(2024, 6, 13))

      result = books_query.still_borrowed_to_member(member).call

      expect(result).not_to include [book2, book3]
      expect(result).to eq [book1]
    end
  end

  describe '#overdue_to_member' do
    it 'prepares #call to result a list of books overdue to member' do
      member = create(:user, :member)

      book1 = create(:book, title: 'Book 1')
      book2 = create(:book, title: 'Book 2')
      book3 = create(:book, title: 'Book 3')
      book4 = create(:book, title: 'Book 4')

      borrowed_at = Date.new(2024, 6, 13)
      due_date = Date.new(2024, 6, 27)

      create(:borrow, member:, book: book1, borrowed_at:, due_date:, returned_at: nil)
      create(:borrow, member: create(:user, email: 'jo@doe.co'), book: book2, borrowed_at:, due_date:, returned_at: nil)
      create(:borrow, member:, book: book3, borrowed_at:, due_date:, returned_at: Date.new(2024, 5, 8))
      create(:borrow, member:, book: book4, borrowed_at: Date.new(2024, 6, 14), due_date: Date.new(2024, 6, 28),
                      returned_at: nil)

      result = books_query.overdue_to_member(member, Date.new(2024, 6, 27)).call

      expect(result).not_to include [book2, book3, book4]
      expect(result).to eq [book1]
    end
  end

  describe '#borrowed' do
    it 'prepares #call to result a list of books borrowed' do
      member = create(:user, :member)

      book1 = create(:book, title: 'Book 1')
      book2 = create(:book, title: 'Book 2')

      create(:borrow, member:, book: book1, returned_at: nil)
      create(:borrow, member:, book: book2, returned_at: Date.new(2024, 5, 8))

      result = books_query.borrowed.call

      expect(result).not_to include book2
      expect(result).to eq [book1]
    end
  end

  describe '#due_at' do
    it 'prepares #call to result a list of books due at date' do
      member = create(:user, :member)

      book1 = create(:book, title: 'Book 1')
      book2 = create(:book, title: 'Book 2')
      book3 = create(:book, title: 'Book 3')

      create(:borrow, member:, book: book1, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27),
                      returned_at: nil)
      create(:borrow, member:, book: book2, borrowed_at: Date.new(2024, 6, 13), due_date: Date.new(2024, 6, 27),
                      returned_at: Date.new(2024, 5, 8))
      create(:borrow, member:, book: book3, borrowed_at: Date.new(2024, 6, 14), due_date: Date.new(2024, 6, 28),
                      returned_at: nil)

      result = books_query.due_at(Date.new(2024, 6, 28)).call

      expect(result).not_to include [book1, book2]
      expect(result).to eq [book3]
    end
  end
end
