class Officer::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :responsibleofficer_user

  def index
  	#change later to all issue where responsible_officer_id = this
  	#Naturally, Responsible officer can only be assigned to Issue in his department
    #@issues_yours = Issue.where("department_id = " + current_user.department_id.to_s + " AND responsible_officer_id = " + current_user.id.to_s).paginate(page: params[:page], per_page: 5)
    if params[:sort] != nil 
      if params[:sort] == 'yours'
        @issues_all = Issue.all
        @issues = Array.new
        @issues_all.each do |issue|
          if issue.found_department(current_user.department_id) && issue.found_officer(current_user.id)
            @issues << issue
          end
        end
      else
        @issues_all = Issue.where("status_id = " + params[:sort])
        @issues = Array.new
        @issues_all.each do |issue|
          if issue.found_department(current_user.department_id)
            @issues << issue
          end
        end
      end
      @issues = @issues.paginate(page: params[:page], per_page: 10)
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

  def show
  	@issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    # Decide if will move Causes and ActionPlans to details view for Officer controls
    @issue_comment = IssueComment.new
    @issuecomments = @issue.issue_comments.where(log_comment: 'f').paginate(page: params[:page],  per_page: 3)
    @issueupdates = @issue.issue_comments.where(log_comment: 't').paginate(page: params[:page],  per_page: 5)
  end

  def sign_closeout
    @issue = Issue.find params[:id]
    @cofd = CloseoutFormDept.find_by_id(params[:cofd])
    if @cofd.officer_id == nil 
      @cofd.officer_id = current_user.id
      if @cofd.save
        @ic= @issue.issue_comments.build({content: "Officer signed Closeout Form.",
            user_id: current_user.id, issue_id: @issue.id })
        @ic.toggle!(:log_comment)
        @ic.save
        flash[:success] = "Successfully signed Closeout form of Issue!"
        redirect_to details_officer_issue_path(@issue)
      end
    end
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    @cof = CloseoutForm.find_by_issue_id(@issue.id)
  end

  private
  def responsibleofficer_user
    redirect_to(root_path) unless current_user.type_id==3
  end
end
