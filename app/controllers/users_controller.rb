class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "会員登録が完了しました"
    else
      render 'new'
    end
  end
  def edit

  end 
  def update
  def update 
    if @user.update(user_params)
      flash[:success] = "プロフィールの編集を完了しました"
      redirect_to user_path(@user)
    else 
      render 'edit' 
    end
  end 
  end
  def show
    @places = @user.places.group('places.id')
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :nickname, :email, :avator, :description, :prefecture, :address, :password,
                                 :password_confirmation)
  end
end