class SessionsController < ApplicationController
  def new
  	
  end

  def create
  	user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) # && user.account_enabled
      # Add condition here later - User account must be verified and enabled to signin
      flash[:success] = 'Successfully loggged in!'
      sign_in user
      redirect_back_or role_control_panel
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    flash[:success] = "Successfully signed out."
    redirect_to signin_url #root_url
  end
end
