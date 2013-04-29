class Auditor::CloseoutFormsController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def create
  	@issue = Issue.find_by_id(params[:closeout_form][:issue_id])
  	redirect_to auditor_issues_path if @issue == nil
  	@closeout_form = @issue.closeout_forms.build(params[:closeout_form])
    outstring = ""
  	if @closeout_form.save
      if @issue.status_id < 5
        @issue.status_id = 5
        if @issue.save
          outstring = " Issue Status has been updated to \"Implemented!\"."
        end
      end
      @ic= @issue.issue_comments.build({content: "Auditor started Closeout Form for Issue.",
            user_id: current_user.id, issue_id: @issue.id })
      @ic.toggle!(:log_comment)
      @ic.save
      if @closeout_form.closeout_form_depts.empty?
        generate_closeoutform_depts(@issue, @closeout_form)
      end
  		flash[:success] = "Closeout Form successfully started!" + outstring + " Refresh the page to see the Departments below."
      redirect_to details_auditor_issue_path(@issue)
      mail_list(@issue) 
    else
      flash[:error]  = "There was an error creating the form."
      redirect_to :back
  	end
  end

  private

  def auditor_user
    redirect_to(root_path) unless current_user.type_id==5
  end

  def generate_closeoutform_depts(issue, cof)
    @cof_dept = cof.closeout_form_depts.build({dept_id: issue.department_id, closeout_form_id: cof.id})
    @cof_dept.save
    issue.next_responsible_departments.each do |nrd|
      @cof_dept=cof.closeout_form_depts.build({dept_id: nrd.department_id, closeout_form_id: cof.id})
      @cof_dept.save
    end
  end

  def mail_list(issue)
    title = "Closeup Form started for one of your Issues"
    content = "One of the Issues you investigated and acted on, "+ issue.title + " has started its Closeout form. Please check back into the site in the Issue details to sign Form."
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
  
end
