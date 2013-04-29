class Officer::CauseCommentsController < ApplicationController
	before_filter :signed_in_user
	before_filter :responsibleofficer_user	

  	def create
	  @cause=Cause.find_by_id(params[:cause_comment][:cause_id])
	  @cause_comment= @cause.cause_comments.build(params[:cause_comment])
	  if @cause_comment.save
	  	flash[:success] = "Comment added!"
	  	redirect_to [:officer, Issue.find(@cause.issue_id), @cause]
	  else
	  	flash[:error] = "You cannot submit a blank comment!"
	  	redirect_to [:officer, Issue.find(@cause.issue_id), @cause]
	  end
	end

	private
	def responsibleofficer_user
      redirect_to(root_path) unless current_user.type_id==3
  	end
end
