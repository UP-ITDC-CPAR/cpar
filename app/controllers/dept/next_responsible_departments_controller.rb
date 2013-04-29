class Dept::NextResponsibleDepartmentsController < ApplicationController
  before_filter :signed_in_user
  before_filter :dept_user

  def update
  	@issue = Issue.find_by_id(params[:next_responsible_department][:issue_id])
  	@nrd = NextResponsibleDepartment.find params[:id]
  	@nrd.dept_status_id = 3
  	if @nrd.update_attributes params[:next_responsible_department]
      flash[:success] = 'Successfully Assigned Officer to Issue. Issue is now Investigating Status (under Department).'
      redirect_to dept_issues_path
      title = "Assigned Officer to an Issue"
      content = "You have been assigned by your Department Head as a Responsible Officer for an Issue. Please check back into the site for the Issue details."
      @officer = User.find(params[:next_responsible_department][:responsible_officer_id])
      @officer.send_notification_email(title, content)
    else
      redirect_to :back, notice: 'There was an error in assigning.'
    end
  end

  private
  def dept_user
    redirect_to(root_path) unless current_user.type_id==2
  end

end
