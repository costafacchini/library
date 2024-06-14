# frozen_string_literal: true

class Dashboard::Librarian
  include ActiveModel::Serializers::JSON

  attr_accessor :total, :total_borrowed, :due_today, :members_overdue

  def attributes
    { 'total' => nil, 'total_borrowed' => nil, 'due_today' => nil, 'members_overdue' => nil }
  end

  def load(_, today)
    self.total = count_books
    self.total_borrowed = count_borrowed
    self.due_today = load_books_due_at(today)
    self.members_overdue = load_members_with_overdue_at(today)
  end

  private

  def count_books
    Book.count
  end

  def count_borrowed
    BooksQuery.new.borrowed.call.count
  end

  def load_books_due_at(today)
    books = BooksQuery.new.due_at(today).call
    books.map do |book|
      Struct.new(:id, :title, :due_date).new(book.id, book.title, book.borrows.first.due_date)
    end
  end

  def load_members_with_overdue_at(today)
    members = UsersQuery.new.with_overdue(today).call
    members.map do |member|
      Struct.new(:id, :name, :books).new(member.id, member.name, books(member))
    end
  end

  def books(member)
    books = []
    member.borrows.each do |borrow|
      book = borrow.book
      books << Struct.new(:id, :title, :due_date).new(book.id, book.title, borrow.due_date)
    end

    books
  end
end
