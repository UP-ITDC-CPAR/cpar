class Auditor::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def index
    # Issues
    @issues = Issue.all
    @issues_new = Issue.where("status_id = 1")
    @issues_verified = Issue.where("status_id = 2")
    @issues_investigating = Issue.where("status_id = 3")
    @issues_correcting = Issue.where("status_id = 4")
    @issues_closeout = Issue.where("status_id = 5")
    @issues_closed = Issue.where("status_id = 6")
    @issues_rejected = Issue.where("status_id = 7 OR status_id = 8")
    # Action Plans
  	@action_plans = ActionPlan.all
  	@action_plans_new = ActionPlan.where("ap_status_id = 1")
  	@action_plans_verified = ActionPlan.where("ap_status_id = 2")
    @action_plans_implemented = ActionPlan.where("ap_status_id = 3")
    @action_plans_pending = ActionPlan.where("ap_status_id = 4")
    @action_plans_closed = ActionPlan.where("ap_status_id = 5")
  	# For reviewing if ACtion Plan properly implemented
    @closeoutforms_started = CloseoutForm.all
    @closeoutforms_finished = CloseoutForm.where(completed: 't')
  end

  private

  def auditor_user
      redirect_to(root_path) unless current_user.type_id==5
  end
end
