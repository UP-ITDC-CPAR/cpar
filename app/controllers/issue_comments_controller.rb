class IssueCommentsController < ApplicationController
	before_filter :signed_in_user
	before_filter :admin_user, only: :destroy

  	def create
	  @issue=Issue.find_by_id(params[:issue_comment][:issue_id])
	  @issuecomment= @issue.issue_comments.build(params[:issue_comment])
	  if @issuecomment.save
	  	flash[:success] = "Comment added!"
	  	redirect_to @issue
	  else
	  	flash[:error] = "You cannot submit a blank comment!"
	  	redirect_to @issue
	  end
	end

	def destroy
	  @issuecomment.destroy
	  flash[:success] = "Successfully deleted comment."
	  redirect_to @issue
	end

	private

	def admin_user
	  @issuecomment = IssueComment.find_by_id(params[:id])
	  @issue= Issue.find_by_id(@issuecomment.issue_id)
	  redirect_to @issue unless current_user.admin?
	end
end
