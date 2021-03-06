class Officer::ActionPlanCommentsController < ApplicationController
	before_filter :signed_in_user
	before_filter :responsibleofficer_user
	
  	def create
	  @action_plan=ActionPlan.find_by_id(params[:action_plan_comment][:action_plan_id])
	  @apcomment= @action_plan.action_plan_comments.build(params[:action_plan_comment])
	  if @apcomment.save
	  	flash[:success] = "Comment added!"
	  	redirect_to [:officer, @action_plan]
	  else
	  	flash[:error] = "You cannot submit a blank comment!"
	  	redirect_to [:officer, @action_plan]
	  end
	end

	private
	def responsibleofficer_user
      redirect_to(root_path) unless current_user.type_id==3
  end
end
