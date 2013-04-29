class Admin::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user

  def index
  	@users = User.all
    @users_enable = User.where(verified: 't', account_enabled: 'f')
  	@users_dept = User.where("type_id = 2")
  	@users_officer = User.where("type_id = 3")
  	@users_qmr = User.where("type_id = 4")
  	@users_auditor = User.where("type_id = 5")
  end

  private

  def admin_user
      redirect_to(root_path) unless current_user.admin?
  end
end
