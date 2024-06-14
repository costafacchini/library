# frozen_string_literal: true

class BooksQuery
  def initialize
    @relation = Book.order(:title)
  end

  def call
    @relation
  end

  def by_expression(expression)
    @relation = @relation.by_expression(expression)

    self
  end

  def still_borrowed_to_member(member_id)
    @relation = @relation.includes(:borrows).where(borrows: { member_id:, returned_at: nil })

    self
  end

  def overdue_to_member(member_id, date)
    @relation = @relation.includes(:borrows).where(borrows: { member_id:, returned_at: nil, due_date: ...date })

    self
  end

  def borrowed
    @relation = @relation.joins(:borrows).where(borrows: { returned_at: nil })

    self
  end

  def due_at(date)
    @relation = @relation.includes(:borrows).where(borrows: { returned_at: nil, due_date: date })

    self
  end
end
