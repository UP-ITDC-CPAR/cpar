class CauseCommentsController < ApplicationController
	before_filter :signed_in_user
	before_filter :admin_user, only: :destroy

  	def create
	  @cause=Cause.find_by_id(params[:cause_comment][:cause_id])
	  @cause_comment= @cause.cause_comments.build(params[:cause_comment])
	  if @cause_comment.save
	  	flash[:success] = "Comment added!"
	  	redirect_to [Issue.find(@cause.issue_id), @cause]
	  else
	  	flash[:error] = "You cannot submit a blank comment!"
	  	redirect_to [Issue.find(@cause.issue_id), @cause]
	  end
	end

	def destroy
	  @cause_comment.destroy
	  flash[:success] = "Successfully deleted comment."
	  redirect_to [Issue.find(@cause.issue_id), @cause]
	end

	private

	def admin_user
	  @cause_comment = CauseComment.find_by_id(params[:id])
	  @cause= Cause.find_by_id(@cause_comment.cause_id)
	  redirect_to @cause unless current_user.admin?
	end
end
