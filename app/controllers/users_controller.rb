class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def new
    redirect_to root_path if signed_in?
    @user = User.new
    @title = 'Sign up'
  end

  def index
    @title = "All users"
    #@users = User.all
    @users = User.paginate(:page => params[:page])
  end


  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    # WHY did this fail on me
    #redirect_to root_path if signed_in?
    # AND I had to use the if..else..end statement below ??
    if signed_in?
      redirect_to root_path if signed_in?
    else
      @user = User.new(params[:user])
      if @user.save
        # Handle a successful save.
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        @title = "Sign up"
        @user.password = ''
        @user.password_confirmation = ''
        render 'new'
      end
    end
  end

  def edit
    #@user = User.find(params[:id]) # moved to correct_user
    @title = "Edit user"
  end

  def update
    #@user = User.find(params[:id]) # moved to correct_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
