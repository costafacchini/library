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
end