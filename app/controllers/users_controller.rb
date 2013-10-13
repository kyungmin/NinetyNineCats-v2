class UsersController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      login_user!(@user)
      redirect_to cats_url
    else
      render :new
    end
  end
end