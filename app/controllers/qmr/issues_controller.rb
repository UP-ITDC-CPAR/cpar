class Qmr::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :qmr_user

  def index
    if params[:sort] != nil
      @issues = Issue.where("status_id = " + params[:sort]).paginate(page: params[:page], per_page: 10)
    else
     @issues = Issue.paginate(page: params[:page], per_page: 10)
    end
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new params[:issue]

    if @issue.save
      @ic= @issue.issue_comments.build({content: "User submitted an Issue.",
            user_id: current_user.id, issue_id: @issue.id })
      @ic.toggle!(:log_comment)
      @ic.save
      flash[:success] = 'The issue has been created!'
      redirect_to qmr_issues_path
    else
      flash[:success] = 'There was an error in creating your issue.'
      redirect_to :back
    end
  end

  def show
    @issue = Issue.find params[:id]
    # moved Causes and ActionPlans to details view
    @issue_comment = IssueComment.new
    @issuecomments = @issue.issue_comments.where(log_comment: 'f').paginate(page: params[:page],  per_page: 3)
    @issueupdates = @issue.issue_comments.where(log_comment: 't').paginate(page: params[:page],  per_page: 5)
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    @cof = CloseoutForm.find_by_issue_id(@issue.id)
  end

  def edit
    @issue = Issue.find params[:id]
  end

  def edit_departments
    @issue = Issue.find params[:id]
    @nrds = depts_added_to_issue(@issue)
    @next_responsible_department = NextResponsibleDepartment.new
  end

  def statuschange
    issue = Issue.find params[:id]
    issue.status_id = params[:stat_id]
    if issue.save
      longtext= "QMR updated Issue status to " + IssueStatus.find(issue.status_id).name + "."
      @ic= issue.issue_comments.build({content: longtext,
            user_id: current_user.id, issue_id: issue.id })
      @ic.toggle!(:log_comment)
      @ic.save
      flash[:success] = "Issue Status updated."
      redirect_to qmr_issue_path
    end
  end

  def notify_deadline
    @issue = Issue.find params[:id]
    notify_officers(@issue)
    flash[:success] = "Successfully notified all officers for this Issue about deadline."
    redirect_to qmr_issue_path
  end

  def sign_closeout
    @issue = Issue.find params[:id]
    @cof = CloseoutForm.find_by_id(params[:cof])
    if @cof.qmr_id == nil 
      @cof.qmr_id = current_user.id
      @cof.closeout_date = Date.today
      @cof.toggle!(:completed)
      if @cof.save
        @issue.status_id = 6 #Closed
        @issue.final_closeout_date = Date.today
        if @issue.save
          @ic= @issue.issue_comments.build({content: "QMR signed Closeout Form and closed Issue.",
            user_id: current_user.id, issue_id: @issue.id })
          @ic.toggle!(:log_comment)
          @ic.save
          flash[:success] = 'Successfully signed Closeout Form and Closed Issue!'
          redirect_to details_qmr_issue_path(@issue)
          notify_list(@cof)
        end
      end
    end
  end

  def update
    issue = Issue.find params[:id]
    if issue.department_id != params[:issue][:department_id]
      # Department has been changed; Only changeable in edit_departments
      new_department1_is_in_depts(issue, params[:issue][:department_id])
    end
    if issue.update_attributes params[:issue]
      @ic= issue.issue_comments.build({content: "QMR updated Issue's details.",
            user_id: current_user.id, issue_id: issue.id })
      @ic.toggle!(:log_comment)
      @ic.save
      flash[:success] = 'The issue has been updated successfuly!'  
      redirect_to qmr_issue_path
    else
      flash[:error]='There was an error in updating your issue.'
      redirect_to :back
    end
  end

  def destroy
    Issue.destroy params[:id]
    redirect_to qmr_issues_path, :notice => 'The issue was successfuly deleted.'
  end

  private

  def qmr_user
      redirect_to(root_path) unless current_user.type_id==4
  end

  def new_department1_is_in_depts(issue, new_dept_id)
    # Use: Pop Department in issue.NRD if it's to be Assigned to issue.Department1
    # If it's not already in issue.NRD, just save the new addition to NRD
    # (Push the PREVIOUS Department1 pushed off Top1 to issue.NRD)
    #depts_under_issue = Array.new #Array of department ids already added
    #outmessage=""
    nrds= NextResponsibleDepartment.where(issue_id: issue.id)
    destroyed=false
    #testmessage=""
    nrds.each do |nrd|
      #testmessage += "["+ nrd.department_id.to_s + ", " + new_dept_id.to_s + "] "
       if nrd.department_id.to_s == new_dept_id.to_s
          #outmessage += "Successfully Popped Department with id of " + new_dept_id + " off NRD. "
          nrd.destroy
          destroyed=true
       end
    end
    if destroyed
      @nrd_new = issue.next_responsible_departments.build({issue_id: issue.id, department_id: issue.department_id, dept_status_id: issue.status_id, responsibility_level: 2 })
      # Add previous 1st Department under Issue to issue.NextResponsibleDepartment
      if @nrd_new.save
        #outmessage += "Successfully Pushed previous Department1 into NRD instead."
      end
    end
    #flash[:success]= outmessage+" || "+testmessage
  end

  def depts_added_to_issue(issue)
    depts_under_issue = Array.new #Array of department ids already added
    depts_under_issue << issue.department_id
    found_dept = true
    nrds= NextResponsibleDepartment.where(issue_id: @issue.id)
    nrds.each do |nrd|
       depts_under_issue << nrd.department_id
    end
    depts_under_issue
  end

  def notify_officers(issue)
    title = "Issue nearing Closeout Date"
    content = "One of the Issues you are investigating, "+ issue.title + " has its closeout date nearing (" + issue.estimated_closeout_date.to_s + "). You can view the Issue details on the site."
    if issue.responsible_officer_id != nil
      officer = User.find(issue.responsible_officer_id)
      officer.send_notification_email(title, content)
    end
    nrds= NextResponsibleDepartment.where(issue_id: issue.id)
    nrds.each do |nrd|
      if nrd.responsible_officer_id != nil
        officer = User.find(nrd.responsible_officer_id)
        officer.send_notification_email(title, content)
      end
    end
  end

  def notify_list(cof)
    issue= Issue.find(cof.issue_id)
    title = "Closeup Form finished and Issue Closed"
    content = "One of the Issues you investigated and acted on, "+ issue.title + " had its Closeout form finished and Issue closed. You can view the Issue log in the Issue's page on site."
    if cof.auditor_id != nil
      officer = User.find(cof.auditor_id)
      officer.send_notification_email(title, content)
    end
    cofd = CloseoutFormDept.where(closeout_form_id: cof.id)
    cofd.each do |d|
      if d.officer_id != nil
        officer = User.find(d.officer_id)
        officer.send_notification_email(title, content)
      end
      if d.dept_head_id != nil
        officer = User.find(d.dept_head_id)
        officer.send_notification_email(title, content)
      end
    end
  end
end
