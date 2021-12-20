class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # session[:user_id] = @user.id # Logs in with sign up I don't really need because I'm not allowing other sign ups. So commenting out just in case sign up does happen
      redirect_to root_url, notice: "Thank you for signing up!"
    else
      render "new"
    end
  end
end

private

def user_params
  params.require(:user).permit(:username, :email, :password, :password_confirmation)
end
