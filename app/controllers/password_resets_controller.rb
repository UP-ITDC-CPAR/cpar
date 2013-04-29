class PasswordResetsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by_email(params[:email])
  	if user
	  	sent = user.send_password_reset # UserMailer call is inside this User method
		if sent
			flash[:success] = "Email sent with password reset instructions."
		else
			flash[:error] = "Email cannot be sent at this time."
		end
  		redirect_to root_url 
  	else
  		redirect_to :back, :notice => "User with that email not found."
  	end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 3.hours.ago
      flash[:error] = "Error - Password Reset request has already expired. Please request a new Password reset email again."
      redirect_to new_password_reset_path
    else 
      if params[:user][:password].length >= 6 && params[:user][:password_confirmation].length >= 6
        if @user.update_attributes(params[:user])
          flash[:success] = "Password succesfully changed. You may now login with your new password."
          redirect_to signin_url
        else
          render :edit
        end
      else
        flash.now[:error] = "Password and Password Confirmation should not be shorter than 6 characters."
        render :edit
      end
    end 
  end #update action

end
