class Qmr::IssueCommentsController < ApplicationController
	before_filter :signed_in_user
	before_filter :qmr_user

  	def create
	  @issue=Issue.find_by_id(params[:issue_comment][:issue_id])
	  @issuecomment= @issue.issue_comments.build(params[:issue_comment])
	  if @issuecomment.save
	  	flash[:success] = "Comment added!"
	  	redirect_to [:qmr, @issue]
	  else
	  	flash[:error] = "You cannot submit a blank comment!"
	  	redirect_to [:qmr, @issue]
	  end
	end

	private

	def qmr_user
      redirect_to(root_path) unless current_user.type_id==4
  	end
end
