class IssuesController < ApplicationController
  before_filter :signed_in_user, only: [:index, :show, :new, :edit]
  before_filter :correct_submitter, only: [:edit, :attach_form]
  before_filter :correct_department, only: [:show]

  def index
    if params[:sort] != nil && params[:sort] == 'yours'  #get issues reported to you or your department
      @issues = Issue.where("user_id = " + current_user.id.to_s).paginate(page: params[:page], per_page: 10)
    else
      if current_user.admin?  #super admin
        @issues = Issue.paginate(page: params[:page], per_page: 10 )
      else
        @issues_all = Issue.all
        @issues = Array.new
        @issues_all.each do |issue|
          if issue.found_department(current_user.department_id)
            @issues << issue
          end
        end
        @issues = @issues.paginate(page: params[:page], per_page: 10)
      end
    end
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new params[:issue]
    if @issue.save
      @ic= @issue.issue_comments.build({content: "User submitted Issue.",
            user_id: current_user.id, issue_id: @issue.id })
      @ic.toggle!(:log_comment)
      @ic.save
      flash[:success] = 'The issue has been created!'
      redirect_to issues_path
    else
      flash[:error]='There was an error in creating your issue.'
      redirect_to :back
    end
  end

  def show
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    @issue_comment = IssueComment.new
    @issuecomments = @issue.issue_comments.where(log_comment: 'f').paginate(page: params[:page],  per_page: 3)
    @issueupdates = @issue.issue_comments.where(log_comment: 't').paginate(page: params[:page],  per_page: 5)
  end

  def attach_form
    @issue = Issue.find params[:id]
    @issue_attachment = IssueAttachment.new
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    @cof = CloseoutForm.find_by_issue_id(@issue.id)
  end

  def edit
    @issue = Issue.find params[:id]
    @issue_attachment = IssueAttachment.new
  end

  def update
    issue = Issue.find params[:id]
    if issue.update_attributes params[:issue]
      @ic= issue.issue_comments.build({content: "User updated their submitted Issue's details.",
            user_id: current_user.id, issue_id: issue.id })
      @ic.toggle!(:log_comment)
      @ic.save
      flash[:success] = "The issue has been updated successfully!"
      redirect_to issue_path  
    else
      flash[:error] = "There was an error in updating your issue."
      redirect_to :back
    end
  end

private
  def correct_department
    @issue = Issue.find params[:id]
    if !current_user.admin? 
      #remove this condition if admin mustn't be allowed to view all Issues in public
      if current_user.id == @issue.user_id
        #flash[:success] = "Viewing your submitted Issue."
      elsif @issue.found_department(current_user.department_id)  
        # Still viewable to secondarily assigned
      else
        flash[:error] = "You cannot view that Issue."
        redirect_to issues_path
      end
    end 
  end

  def correct_submitter
    @issue = Issue.find params[:id]
    if current_user.id != @issue.user_id 
      flash[:error] = "You cannot Edit that Issue."
      redirect_to issue_path
    end
  end

end
