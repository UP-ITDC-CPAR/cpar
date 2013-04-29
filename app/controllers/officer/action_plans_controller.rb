class Officer::ActionPlansController < ApplicationController
before_filter :signed_in_user
before_filter :responsibleofficer_user

  def new
  	@action_plan = ActionPlan.new
    #@issues = Issue.where("department_id = ?", current_user.department_id).paginate(page: params[:page], per_page: 5)
    #@nrds = NextResponsibleDepartment.where("responsible_officer_id =  " + current_user.id.to_s)
    #@nrds.each do |n|
     # @issues << Issue.find_by_id(n.issue_id)
    #end
    #change later to all issue where responsible_officer_id = this
    #Naturally, Responsible officer can only be assigned to Issue in his department
  end

  def create
  	@action_plan = ActionPlan.new(params[:action_plan])
    @action_plan.responsible_officer_id = current_user.id
    #since those who make action plans are responsible officers
    @issue = Issue.find(params[:action_plan][:issue_id])
  	if @action_plan.save
      @ic= @issue.issue_comments.build({content: "Officer added an Action Plan to Issue.",
            user_id: current_user.id, issue_id: @issue.id })
      @ic.toggle!(:log_comment)
      @ic.save
      @ac= @action_plan.action_plan_comments.build({content: "Officer submitted Action Plan.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
  		flash[:success] = "Successfully added Action Plan! Next, add an Activity for this Action Plan." 
  	  redirect_to new_officer_action_plan_activity_path(@action_plan)
  	else
  		flash.now[:error] = "Please fill in the fields properly." 
  		render 'new'
  	end
  end

  def implemented
    @action_plan = ActionPlan.find params[:id]
    @action_plan.toggle!(:implemented)
    if @action_plan.save
      @ac= @action_plan.action_plan_comments.build({content: "Officer marked Action Plan as Implemented.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Action Plan successfully marked as implemented. 
      Status now pending to be changed to Implemented."
      redirect_to officer_action_plan_path
    end
  end

  def edit
  	@action_plan = ActionPlan.find params[:id]
  end

  def index
    if params[:sort] != nil
      if params[:sort] == 'yours'
        @action_plans = ActionPlan.where("responsible_officer_id = "+current_user.id.to_s).paginate(page: params[:page], per_page: 10)
      else
        @action_plans = ActionPlan.where("ap_status_id = " + params[:sort]).paginate(page: params[:page], per_page: 10)
      end
    else
     @action_plans = ActionPlan.paginate(page: params[:page], per_page: 10)
    end
  end

  def update
    @action_plan = ActionPlan.find params[:id]
    if @action_plan.update_attributes(params[:action_plan])
      @ac= @action_plan.action_plan_comments.build({content: "Officer updated Action Plan details.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Action Plan updated."
      redirect_to officer_action_plan_path
    else
      flash.now[:error] = "Please don't leave the fields blank."
      render 'edit'
    end
  end 

  def show
  	@action_plan = ActionPlan.find params[:id]
    @activities = @action_plan.activities.paginate(page: params[:page],  per_page: 5)
    @actionplan_comment = ActionPlanComment.new
    @ap_comments = @action_plan.action_plan_comments.where(log_comment: 'f').paginate(page: params[:page],  per_page: 3)
    @ap_updates = @action_plan.action_plan_comments.where(log_comment: 't').paginate(page: params[:page],  per_page: 5)
  end

  private

  def responsibleofficer_user
      redirect_to(root_path) unless current_user.type_id==3
  end
end
