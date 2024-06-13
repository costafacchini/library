class V1::BorrowsController < APIController
  def create
    member_id = current_user.id
    borrow = Borrow.new(borrow_params.merge(member_id:))

    if borrow.save
      render json: borrow, status: :created
    else
      render json: { message: borrow.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def borrow_params
    params.require(:borrow).permit(:book_id, :borrowed_at)
  end
end
