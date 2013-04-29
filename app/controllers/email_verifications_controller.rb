class EmailVerificationsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by_email(params[:email])
  	if user
  		user.send_verification_email # UserMailer call is inside this User method
  		redirect_to root_url, :notice => "New Verification Email sent. Please check your email."
  	else
  		redirect_to :back, :notice => "User with that email not found."
  	end
  end

  def edit
  	@user = User.find_by_verification_token!(params[:id])
    if @user.verified == true
      flash[:error] = "You have already verified your email. 
        Please wait for an email when Admin approves your account."
      redirect_to root_url
  	elsif @user.verification_sent_at < 2.weeks.ago
  		flash[:error] = "Your email verification link has already expired, 
            please request to resend another verification email."
      redirect_to new_email_verification_path
  	else
      @user.verified = true
      if @user.save
        flash[:success] = "Successfully verified your email! 
              Please wait to receive an email when Admin approves your account."
        redirect_to root_url
      end
  	end

  end
end
