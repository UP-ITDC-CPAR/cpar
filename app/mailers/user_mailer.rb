class UserMailer < ActionMailer::Base
  default from: "webcpartest@gmail.com" #{}"smtp://localhost:1025" #"WebCPAR <smtp://localhost:1025>"

  def welcome_email(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Successfully Registered to Web CPAR!")
  end

  def password_reset(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "[Web CPAR] Password Reset Request")
  end

  def verify_email(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "[Web CPAR] Verify Your Email")
  end

  def notify_email(user, msgtitle, content)
    @user = user
    @msgtitle = "[Web CPAR] " + msgtitle
    @content = content
    mail(:to => "#{user.name} <#{user.email}>", :subject => @msgtitle)
  end
end