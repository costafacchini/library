class UsersQuery
  def initialize
    @relation = User.order(:id)
  end

  def call
    @relation
  end

  def with_overdue(date)
    @relation = @relation.includes(borrows: :book).where(borrows: { returned_at: nil, due_date: ..date })

    self
  end
end
