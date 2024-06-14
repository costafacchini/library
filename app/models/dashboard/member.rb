# frozen_string_literal: true

class Dashboard::Member
  include ActiveModel::Serializers::JSON

  attr_accessor :my_books, :overdue

  def attributes
    { 'my_books' => nil, 'overdue' => nil }
  end

  def load(user, today)
    self.my_books = load_my_books(user)
    self.overdue = load_overdue(user, today)
  end

  private

  def load_my_books(user)
    my_books = []

    books = BooksQuery.new.still_borrowed_to_member(user).call
    books.each do |book|
      borrow = book.borrows.first
      my_books << Struct.new(:id, :title, :borrowed_at, :due_date).new(book.id, book.title, borrow.borrowed_at,
                                                                       borrow.due_date)
    end

    my_books
  end

  def load_overdue(user, today)
    books = BooksQuery.new.overdue_to_member(user, today).call
    books.map do |book|
      Struct.new(:id, :title, :due_date).new(book.id, book.title, book.borrows.first.due_date)
    end
  end
end
