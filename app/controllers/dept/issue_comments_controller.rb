class Dept::IssueCommentsController < ApplicationController
	before_filter :signed_in_user
	before_filter :dept_user

  	def create
	  @issue=Issue.find_by_id(params[:issue_comment][:issue_id])
	  @issuecomment= @issue.issue_comments.build(params[:issue_comment])
	  if @issuecomment.save
	  	flash[:success] = "Comment added!"
	  	redirect_to [:dept, @issue]
	  else
	  	flash[:error] = "You cannot submit a blank comment!"
	  	redirect_to [:dept, @issue]
	  end
	end

	private
  	def dept_user
      redirect_to(root_path) unless current_user.type_id==2
  	end
end
