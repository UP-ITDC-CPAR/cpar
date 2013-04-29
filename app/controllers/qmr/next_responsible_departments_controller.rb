class Qmr::NextResponsibleDepartmentsController < ApplicationController
  before_filter :signed_in_user
  before_filter :qmr_user

  def create
  	@issue = Issue.find_by_id(params[:next_responsible_department][:issue_id])
  	@next_responsible_department = @issue.next_responsible_departments.build(params[:next_responsible_department])
#    if department_notexist(@issue, params[:next_responsible_department][:department_id])
      if @next_responsible_department.save
        @ic= @issue.issue_comments.build({content: "QMR added a Department to Issue.",
            user_id: current_user.id, issue_id: @issue.id })
        @ic.toggle!(:log_comment)
        @ic.save
        flash[:success] = "Department Successfully Added!"
        redirect_to qmr_issue_path(@issue)
      else
        flash[:error]  = "There was an error adding that Department."
        redirect_to :back
      end
 #   else
   #   flash[:error]  = "That Department is already added to this Issue!"
  #    redirect_to :back
    #end
  end

  def destroy
    @issue= Issue.find(params[:issue_id])
    @next_responsible_department = @issue.next_responsible_departments.find_by_id(params[:id])
    @next_responsible_department.destroy
    @ic= @issue.issue_comments.build({content: "QMR removed Department from Issue.",
            user_id: current_user.id, issue_id: @issue.id })
      @ic.toggle!(:log_comment)
      @ic.save
    flash[:success] = "Department removed!"
    redirect_to qmr_issue_path(@issue)
  end

  private

  def qmr_user
      redirect_to(root_path) unless current_user.type_id==4
  end

  def department_notexist(issue, dept_id)
    depts_under_issue = Array.new #Array of department ids already added
    depts_under_issue << issue.department_id
    found_dept = true
    nrds= NextResponsibleDepartment.where(issue_id: issue.id)
    nrds.each do |nrd|
       depts_under_issue << nrd.department_id
     end
    depts_under_issue.each do |d|
      if dept_id == d
        found_dept=false
      end
    end
    found_dept
  end

end
