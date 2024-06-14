# frozen_string_literal: true

class V1::BorrowsController < APIController
  def create
    member_id = current_user.id
    borrow = Borrow.new(borrow_params_create.merge(member_id:))

    if borrow.save
      render json: borrow, status: :created
    else
      render json: { message: borrow.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    borrow = Borrow.find(params[:id])
    borrow.update(borrow_params_update)

    render json: { message: 'Book returned successfully' }, status: :ok
  end

  private

  def borrow_params_create
    params.require(:borrow).permit(:book_id, :borrowed_at)
  end

  def borrow_params_update
    params.require(:borrow).permit(:returned_at)
  end
end
