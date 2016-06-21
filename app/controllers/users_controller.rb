class UsersController < ApplicationController

   def promote
       @user = User.find(params[:id])
       puts(@user.inspect)
       @user.update_attribute(:admin, true)
       redirect_to :action => :index, status: 303
   end
   def demote
       @user = User.find(params[:id])
       puts(@user.inspect)
       @user.update_attribute(:admin, false)
       redirect_to :action => :index, status: 303
   end
  def new
      @user = User.new
  end

  def index
    if !admin?
        redirect_to root_path
    end
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    #debugger
  end

  def create
    @user = User.new(user_params)
    if @user.save
        log_in @user
        redirect_to root_path
    else
        render 'new'
    end
  end

  def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to :action => :index, status: 303
  end

  private

    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :admin)
    end
end
