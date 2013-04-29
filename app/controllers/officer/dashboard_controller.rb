class Officer::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :responsibleofficer_user

  def index
  	@action_plans = ActionPlan.all
    @action_plans_yours = ActionPlan.where("responsible_officer_id = "+current_user.id.to_s)
    @action_plans_new = ActionPlan.where("ap_status_id = 1")
    @action_plans_verified = ActionPlan.where("ap_status_id = 2")
    @action_plans_implemented = ActionPlan.where("ap_status_id = 3")
    @action_plans_pending = ActionPlan.where("ap_status_id = 4")
    @action_plans_closed = ActionPlan.where("ap_status_id = 5")
    # Issues
    @issues_all = Issue.all
    @issues = Array.new
    @issues_all.each do |issue|
      if issue.found_department(current_user.department_id)
        @issues << issue
      end
    end
    #@issues = @issue.all
    @issues_all_yours = Issue.all
    @issues_yours = Array.new
    @issues_all_yours.each do |issue|
      if issue.found_department(current_user.department_id) && issue.found_officer(current_user.id)
        @issues_yours << issue
      end
    end
    @issues_all_new = Issue.where("status_id = 1")
    @issues_new = Array.new
    @issues_all_new.each do |issue|
      if issue.found_department(current_user.department_id)
        @issues_new << issue
      end
    end
    @issues_all_verified = Issue.where("status_id = 2")
    @issues_verified = Array.new
    @issues_all_verified.each do |issue|
      if issue.found_department(current_user.department_id)
        @issues_verified << issue
      end
    end
    @issues_all_investigating = Issue.where("status_id = 3")
    @issues_investigating = Array.new
    @issues_all_investigating.each do |issue|
      if issue.found_department(current_user.department_id)
        @issues_investigating << issue
      end
    end
    @issues_all_correcting = Issue.where("status_id = 4")
    @issues_correcting = Array.new
    @issues_all_correcting.each do |issue|
      if issue.found_department(current_user.department_id)
        @issues_correcting << issue
      end
    end
    @issues_all_closeout = Issue.where("status_id = 5")
    @issues_closeout = Array.new
    @issues_all_closeout.each do |issue|
      if issue.found_department(current_user.department_id)
        @issues_closeout << issue
      end
    end
    @issues_all_closed = Issue.where("status_id = 6")
    @issues_closed = Array.new
    @issues_all_closed.each do |issue|
      if issue.found_department(current_user.department_id)
        @issues_closed << issue
      end
    end
    @issues_all_rejected = Issue.where("status_id = 7")
    @issues_rejected = Array.new
    @issues_all_rejected.each do |issue|
      if issue.found_department(current_user.department_id)
        @issues_rejected << issue
      end
    end
    # It's long but it works, since can't use scope on array
  end

  private

  def responsibleofficer_user
      redirect_to(root_path) unless current_user.type_id==3
  end
end