class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create]

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def create
    params[:user][:public_key] = session[:public_key] if session[:public_key]
    params[:user][:password] ||= SecureRandom.hex(30)
    @user = User.new params[:user]

    if @user.save!
      sign_in_and_redirect(:user, @user)
    else
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
