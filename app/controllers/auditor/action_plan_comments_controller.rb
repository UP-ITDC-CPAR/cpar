class Auditor::ActionPlanCommentsController < ApplicationController
	before_filter :signed_in_user
	before_filter :auditor_user
	
  	def create
	  @action_plan=ActionPlan.find_by_id(params[:action_plan_comment][:action_plan_id])
	  @apcomment= @action_plan.action_plan_comments.build(params[:action_plan_comment])
	  if @apcomment.save
	  	flash[:success] = "Comment added!"
	  	redirect_to [:auditor, @action_plan]
	  else
	  	flash[:error] = "You cannot submit a blank comment!"
	  	redirect_to [:auditor, @action_plan]
	  end
	end

	private
	def auditor_user
      redirect_to(root_path) unless current_user.type_id==5
  	end
end
