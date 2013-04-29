class ActionPlansController < ApplicationController
  before_filter :signed_in_user
  before_filter :not_employee_user

  def index
    @action_plans = ActionPlan.paginate(page: params[:page],  per_page: 15)
  end

  def show
  	@action_plan = ActionPlan.find params[:id]
    @activities = @action_plan.activities.paginate(page: params[:page],  per_page: 5)
    @actionplan_comment = ActionPlanComment.new
    @ap_comments = @action_plan.action_plan_comments.where(log_comment: 'f').paginate(page: params[:page],  per_page: 3)
    @ap_updates = @action_plan.action_plan_comments.where(log_comment: 't').paginate(page: params[:page],  per_page: 5)
  end

  private

  def not_employee_user
    redirect_to(root_path) if current_user.type_id==6
  end

end
