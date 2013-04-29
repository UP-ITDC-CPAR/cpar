class Auditor::ActionPlansController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def index
    if params[:sort] != nil
      @action_plans = ActionPlan.where("ap_status_id = " + params[:sort]).paginate(page: params[:page], per_page: 10)
    else
     @action_plans = ActionPlan.paginate(page: params[:page], per_page: 10)
    end
  end

  def review
    @action_plan = ActionPlan.find params[:id]
    @action_plan.ap_reviewer_id = current_user.id
    @action_plan.toggle!(:approved)
    @action_plan.ap_status_id = 2
    @action_plan.final_review_date = Date.today
    if @action_plan.save
      @ac= @action_plan.action_plan_comments.build({content: "Auditor reviewed Action Plan.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Action Plan successfully reviewed."
      redirect_to auditor_action_plan_path
    end
  end

  def reject
    @action_plan = ActionPlan.find params[:id]
    @action_plan.ap_reviewer_id = current_user.id
    @action_plan.ap_status_id = 6 #previously Rejected was 5
    if @action_plan.save
      @ac= @action_plan.action_plan_comments.build({content: "Auditor rejected Action Plan.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Action Plan Rejected. It will now be closed for edits."
      redirect_to auditor_action_plan_path
    end
  end

  def activity_statuschange
    @action_plan = ActionPlan.find params[:id]
  end

  def update_activities
    @action_plan = ActionPlan.find params[:id]
    activities_approved = Array.new
    activities_rejected = Array.new
    if params[:action_plan][:approve_list] != nil
      params[:action_plan][:approve_list].each do |act_id|
        if in_opposite_list(act_id, params[:action_plan][:reject_list]) == false
          act = Activity.find(act_id)
          # append to final approve array of Activities if no conflict
          activities_approved << act
        end
      end
    end
    if params[:action_plan][:reject_list] != nil
      params[:action_plan][:reject_list].each do |act_id|
        if in_opposite_list(act_id, params[:action_plan][:approve_list]) == false
          act = Activity.find(act_id)
          # append to final reject array of Activities if no conflict
          activities_rejected << act
        end
      end
    end
    if activities_approved != nil
      activities_approved.each do |a|
        # approve them one at a time
        a.status_id = 2 #Reviewed/ Initial Approval
        a.save
      end
    end
    if activities_rejected != nil
      activities_rejected.each do |a|
        # reject them one at a time
        a.status_id = 6 #Rejected
        a.save
      end
    end
    #flash[:success] =  "Status: "+ activities_approved.count.to_s + " activities approved, "+ activities_rejected.count.to_s+" activities rejected"
    #redirect_to :back
    if activities_rejected.count == 0
      activities_all_approved_check(@action_plan, 2)
    else
      flash[:success] = "Activities successfully reviewed. Not all are approved yet."
      redirect_to auditor_action_plan_path(@action_plan)
    end
  end

  def update_activities2
    @action_plan = ActionPlan.find params[:id]
    activities_approved = Array.new
    activities_reimplement = Array.new
    if params[:action_plan][:approve_list] != nil
      params[:action_plan][:approve_list].each do |act_id|
        if in_opposite_list(act_id, params[:action_plan][:reimplement_list]) == false
          act = Activity.find(act_id)
          # append to final approve array of Activities if no conflict
          activities_approved << act
        end
      end
    end
    if params[:action_plan][:reimplement_list] != nil
      params[:action_plan][:reimplement_list].each do |act_id|
        if in_opposite_list(act_id, params[:action_plan][:approve_list]) == false
          act = Activity.find(act_id)
          # append to final reject array of Activities if no conflict
          activities_reimplement << act
        end
      end
    end
    if activities_approved != nil
      activities_approved.each do |a|
        # approve them one at a time
        a.status_id = 4 #Approved Implementation
        a.actual_date = Date.today
        a.save
      end
    end
    if activities_reimplement != nil
      activities_reimplement.each do |a|
        # mark as reimplement one at a time
        a.status_id = 5 #Reimplement
        a.save
      end
    end
    #flash[:success] =  "Status: "+ activities_approved.count.to_s + " activities approved, "+ activities_rejected.count.to_s+" activities rejected"
    #redirect_to :back
    if activities_reimplement.count == 0
      activities_all_implemented_check(@action_plan, 4)
    else 
      @action_plan.ap_status_id = 4 #Implemented (3) to Pending (4)
      # Some to be Reimplemented
      @action_plan.save
      flash[:success] = "Activities Implementation successfully reviewed. Some are still for Reimplementation or not yet Reviewed."
      redirect_to auditor_action_plan_path(@action_plan)
    end
  end

  def implemented
    @action_plan = ActionPlan.find params[:id]
    @action_plan.ap_status_id = 3
    @action_plan.implementation_reviewer_id = current_user.id
    @action_plan.final_implementation_review_date = Date.today
    if @action_plan.save
      @ac= @action_plan.action_plan_comments.build({content: "Auditor reviewed and approved Action Plan Implementation.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Action Plan Marked as Implemented."
      redirect_to auditor_action_plan_path
    end
  end

  def not_implemented
    @action_plan = ActionPlan.find params[:id]
    @action_plan.toggle!(:implemented)
    @officer = User.find(@action_plan.responsible_officer_id)
    if @action_plan.save
      @ac= @action_plan.action_plan_comments.build({content: "Auditor marked Action Plan as not yet Implemented fully.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Action Plan Marked as not yet fully Implemented. Officer will receive a notification about this."
      redirect_to auditor_action_plan_path
      title = "Submitted Action Plan was marked as not yet Implemented"
      content = "Your Submitted Action Plan was deemed not yet fully Implemented by Auditor, please redo your Implementation or finish more Activities for this Action Plan."
      @officer.send_notification_email(title, content)
    end
  end

  def show
  	@action_plan = ActionPlan.find params[:id]
    @activities = @action_plan.activities.paginate(page: params[:page],  per_page: 5)
    @actionplan_comment = ActionPlanComment.new
    @ap_comments = @action_plan.action_plan_comments.where(log_comment: 'f').paginate(page: params[:page],  per_page: 3)
    @ap_updates = @action_plan.action_plan_comments.where(log_comment: 't').paginate(page: params[:page],  per_page: 5)
  end

  def destroy
    ActionPlan.find(params[:id]).destroy
    flash[:success] = "Action Plan destroyed."
    redirect_to auditor_action_plans_path
  end

  private

  def auditor_user
      redirect_to(root_path) unless current_user.type_id==5
  end

  def in_opposite_list(id, arrayparams)
    found = false
    if arrayparams != nil
      arrayparams.each do |a|
        if id == a
          found = true
        end
      end
    end
    found
  end

  def activities_all_approved_check(action_plan, stat_id)
    all_approved = true
    if action_plan.activities != nil
      action_plan.activities.each do |act|
        if act.status_id != stat_id && act.status_id != 6 
        # 2 is the status_id for Approved/Verified Activity, 6 for Rejected
        # Basically now ignores Rejected activities in checking if all Approved
          all_approved = false
        end
      end
    end
    # Officer should delete activities that got rejected
    if all_approved
      action_plan.ap_status_id = 2
      # New to Verified and Verified to Implemented is +1
      action_plan.ap_reviewer_id = current_user.id
      action_plan.final_review_date = Date.today
      if action_plan.save
        @ac= @action_plan.action_plan_comments.build({content: "Auditor reviewed Action Plan.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
        @ac.toggle!(:log_comment)
        @ac.save
        flash[:success] = "All Activities marked as Approved. Action Plan successfully reviewed."
        redirect_to auditor_action_plan_path(action_plan)
      end
    else
      # Not all Approved yet
      flash[:success] = "Activities successfully reviewed. Not all are approved yet."
      redirect_to auditor_action_plan_path(action_plan)
    end
  end

  def activities_all_implemented_check(action_plan, stat_id)
    all_implemented = true
    if action_plan.activities != nil
      action_plan.activities.each do |act|
        if act.status_id != stat_id && act.status_id != 6 
        # Basically ignores Rejected activities in checking if all Approved
          all_implemented = false
        end
      end
    end
    if all_implemented
      action_plan.ap_status_id = 5 
      # Implemented to Closed 
      action_plan.implementation_reviewer_id = current_user.id
      action_plan.final_implementation_review_date = Date.today
      if action_plan.save
        @ac= @action_plan.action_plan_comments.build({content: "Auditor reviewed Action Plan Implementation and closed Action Plan.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
        @ac.toggle!(:log_comment)
        @ac.save
        # Insert here checking if ALL Action Plans in Issue are Closed
        if check_all_action_plans_closed(action_plan.issue_id)
          @issue=Issue.find(action_plan.issue_id)
          start_closeout_form(@issue)
          #flash[:success] = "All Activities Implementation reviewed. Action Plan Status updated to Closed. Starting Closeout Form."
          #redirect_to auditor_action_plan_path(action_plan)
        else
          flash[:success] = "All Activities Implementation successfully reviewed. Action Plan Implementation successfully reviewed and Closed."
          redirect_to auditor_action_plan_path(action_plan)
        end
      end
    else
      action_plan.ap_status_id = 4 #Implemented (3) to Pending (4)
      # Some to be Reimplemented
      action_plan.save
      flash[:success] = "Activities Implementation successfully reviewed. Some are still for Reimplementation or not yet Reviewed."
      redirect_to auditor_action_plan_path(action_plan)
    end
  end

  def check_all_action_plans_closed(issue_idd)
    action_plans = ActionPlan.where(issue_id: issue_idd)
    all_closed = true
    if action_plans != nil
      action_plans.each do |ap|
        if ap.ap_status_id != 5 && ap.ap_status_id != 6 #Ignore Rejected APs again
          all_closed = false
        end
      end
    end
    all_closed
  end

  def start_closeout_form(issue) #functions like a better COF create action
    @closeout_form = issue.closeout_forms.build({issue_id: issue.id, auditor_id: current_user.id})
    if @closeout_form.save
      if issue.status_id < 5
         issue.status_id = 5 #Update Issue Status to Implemented
         issue.save
      end
      if @closeout_form.closeout_form_depts.empty?
        generate_closeoutform_depts(issue, @closeout_form)
      end
      @ic= issue.issue_comments.build({content: "Closeout Form for Issue started.",
            user_id: current_user.id, issue_id: issue.id })
      @ic.toggle!(:log_comment)
      @ic.save
      flash[:success] = "Closeout Form started. All Activities Implementation reviewed, Action Plan Status updated to Closed."
      redirect_to details_auditor_issue_path(issue)
      mail_list(issue)
    end
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
