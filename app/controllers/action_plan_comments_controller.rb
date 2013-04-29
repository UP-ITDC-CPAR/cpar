class ActionPlanCommentsController < ApplicationController
	before_filter :signed_in_user
	before_filter :admin_user, only: :destroy

  	def create
	  @action_plan=ActionPlan.find_by_id(params[:action_plan_comment][:action_plan_id])
	  @apcomment= @action_plan.action_plan_comments.build(params[:action_plan_comment])
	  if @apcomment.save
	  	flash[:success] = "Comment added!"
	  	redirect_to @action_plan
	  else
	  	flash[:error] = "You cannot submit a blank comment!"
	  	redirect_to @action_plan
	  end
	end

	def destroy
	  @apcomment.destroy
	  flash[:success] = "Successfully deleted comment."
	  redirect_to @action_plan
	end

	private

	def admin_user
	  @apcomment = ActionPlanComment.find_by_id(params[:id])
	  @action_plan= ActionPlan.find_by_id(@apcomment.action_plan_id)
	  redirect_to @action_plan unless current_user.admin?
	end
end
