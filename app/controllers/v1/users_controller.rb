class V1::UsersController < APIController
  def index
    users = User.all

    render json: users, status: :ok
  end

  def update
    user = User.find(params[:id])

    user.update(user_params)

    render status: :ok
  end

  private

  def user_params
    params.require(:user).permit(policy(self).permitted_attributes)
  end
end