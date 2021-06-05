class UsersController < ApplicationController
  before_action :authenticate_user!

  
  def follow
    @user = User.find(params[:id])
    @users = @user.follower
  end
  
  def follower
    @user = User.find(params[:id])
    @users = @user.followed
  end

  def index
    @user = current_user
    @users = User.all
    @booknew = Book.new
    @books = Book.all
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @booknew = Book.new
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render "edit"
  else
    redirect_to user_path(current_user)
  end
end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
    redirect_to user_path(@user.id),notice: 'Book was successfully updated!'
    else
      render :edit
  end
end

private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
