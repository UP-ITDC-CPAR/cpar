class Dept::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :dept_user
  before_filter :correct_department, only: :show

  def index
    if params[:sort] != nil
      @issues_all = Issue.where("status_id = " + params[:sort])
      @issues = Array.new
      @issues_all.each do |issue|
        if issue.found_department(current_user.department_id)
          @issues << issue
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

  def sign_closeout
    @issue = Issue.find params[:id]
    @cofd = CloseoutFormDept.find_by_id(params[:cofd])
    if @cofd.dept_head_id == nil 
      @cofd.dept_head_id = current_user.id
      if @cofd.save
        @ic= @issue.issue_comments.build({content: "Dept Head signed Closeout Form.",
            user_id: current_user.id, issue_id: @issue.id })
        @ic.toggle!(:log_comment)
        @ic.save
        flash[:success] = "Successfully signed Closeout form of Issue!"
        redirect_to details_dept_issue_path(@issue)
      end
    end
  end

  def sign_closeout2
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
        redirect_to details_dept_issue_path(@issue)
      end
    end
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    @cof = CloseoutForm.find_by_issue_id(@issue.id)
  end

  def update
    # Dept/Issues update Would only ever be called by Assign (assign Officer) button
    @issue = Issue.find params[:id]
    @issue.status_id = 3 # Change from Verified to Investigating
    # Sure Verified first because of Assign form condition
    if @issue.update_attributes params[:issue]
      @ic= @issue.issue_comments.build({content: "Dept Head assigned an Officer to Issue.",
            user_id: current_user.id, issue_id: @issue.id })
      @ic.toggle!(:log_comment)
      @ic.save
      flash[:success] = 'Successfully Assigned Officer to Issue. Issue is now Investigating.'
      redirect_to dept_issues_path
      title = "Assigned Officer to an Issue"
      content = "You have been assigned by your Department Head as a Responsible Officer for an Issue. Please check back into the site for the Issue details."
      @officer = User.find(params[:issue][:responsible_officer_id])
      @officer.send_notification_email(title, content)
    else
      flash[:error] = 'There was an error in assigning.'
      redirect_to :back
    end
  end

  def update_date
    @issue = Issue.find params[:id]
    #@issue.estimated_closeout_date = params[:issue][:estimated_closeout_date]
    if @issue.update_attributes params[:issue]
      @ic= @issue.issue_comments.build({content: "Dept Head updated Closeout Date for Issue.",
            user_id: current_user.id, issue_id: @issue.id })
      @ic.toggle!(:log_comment)
      @ic.save
      flash[:success] = "Successfully updated Issue Closeout date!"
      redirect_to [:dept, @issue]
    else
      flash[:error] = "There was an error saving your chosen date."
      redirect_to :back
    end
  end

  def show
  	@issue = Issue.find params[:id]
    @users = User.where("department_id = " + current_user.department_id.to_s + " AND type_id = 3")
    # moved Causes and ActionPlans to details view
    @users_dept = User.where("department_id = " + current_user.department_id.to_s + " AND type_id = 2")
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    # Department Head assign
    @nrd= nrd_for_this(@issue)
    @issue_comment = IssueComment.new
    @issuecomments = @issue.issue_comments.where(log_comment: 'f').paginate(page: params[:page],  per_page: 3)
    @issueupdates = @issue.issue_comments.where(log_comment: 't').paginate(page: params[:page],  per_page: 5)
  end

  private
  def dept_user
      redirect_to(root_path) unless current_user.type_id==2
  end

  def nrd_for_this(issue)
    @nrds = NextResponsibleDepartment.where("issue_id = ?", issue.id)
    my_nrd = NextResponsibleDepartment.new
    @nrds.each do |n|
      if n.department_id == current_user.department_id
        my_nrd=n
      end
    end
    my_nrd
  end

  def correct_department
    @issue = Issue.find params[:id]
    @nrds = NextResponsibleDepartment.where("issue_id = ?", @issue.id)
    found_nrds = false
    @nrds.each do |n|
      if n.department_id == current_user.department_id
        found_nrds = true
      end
    end
    if found_nrds
      #flash[:success] = "Viewing Issue Secondarily assigned to your Department" 
    elsif current_user.department_id != @issue.department_id
      flash[:error] = "You cannot view an Issue not assigned to your Department."
      redirect_to dept_issues_path
    end
  end
end
