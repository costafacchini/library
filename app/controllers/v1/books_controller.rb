class V1::BooksController < ApplicationController
  def index
    expression = params[:expression]

    books = BooksQuery.new.by_expression(expression).call

    render json: books, status: :ok
  end

  def show
    book = Book.find(params[:id])

    render json: book, status: :ok
  end

  def create
    book = Book.create(book_params)

    if book.save
      render json: book, status: :created
    else
      render json: { message: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    book = Book.find(params[:id])

    if book.update(book_params)
      render json: book, status: :ok
    else
      render json: { message: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy

    render status: :no_content
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies)
  end
end
