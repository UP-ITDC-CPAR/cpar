class Officer::CauseAttachmentsController < ApplicationController
  before_filter :signed_in_user
  before_filter :responsibleofficer_user
  before_filter :assigned_officer, only: :create

  def create
  	@cause = Cause.find_by_id(params[:cause_attachment][:cause_id])
    @cause_attachment = @cause.cause_attachments.build(params[:cause_attachment])
    @issue = Issue.find(@cause.issue_id)
    if @cause_attachment.save
      @cc= @cause.cause_comments.build({content: "User attached a file to Cause.",
            user_id: current_user.id, cause_id: @cause.id })
      @cc.toggle!(:log_comment)
      @cc.save
      flash[:success] = "File successfully Attached!"
      redirect_to [:officer, @issue, @cause]
    else
      flash[:error]  = "There was an error saving your file."
      redirect_to :back
    end
  end

  def destroy
  	@cause= Cause.find(params[:cause_id])
    @issue = Issue.find(@cause.issue_id)
    #redirect_to officer_issue_cause_path(@cause) if @cause.nil?
    @cause_attachment = @cause.cause_attachments.find_by_id(params[:id])
  	@cause_attachment.destroy
    @cc= @cause.cause_comments.build({content: "User deleted an attached file from Issue.",
            user_id: current_user.id, cause_id: @cause.id })
    @cc.toggle!(:log_comment)
    @cc.save
    flash[:success] = "File successfully removed from Cause!"
    redirect_to [:officer, @issue, @cause]
  end

  private
  	def responsibleofficer_user
      redirect_to(root_path) unless current_user.type_id==3
  	end

  	def assigned_officer 
	    #@issue = Issue.find(params[:id])
	    @cause = Cause.find_by_id(params[:cause_attachment][:cause_id])
      @issue = Issue.find(@cause.issue_id)
	    @nrds = NextResponsibleDepartment.where("issue_id = ?", @issue.id)
	    found_nrds = false
	    @nrds.each do |n|
	      if n.responsible_officer_id == current_user.id
	        found_nrds = true
	      end
	    end
	    if found_nrds
	      flash[:success] = "Root Cause Adding/Editing by Secondary Officer" 
	    elsif @issue.responsible_officer_id != current_user.id
	      flash[:error] = "You're not allowed to Add or Edit Causes for Issues not assigned to you."
	      redirect_to [:officer, @issue, @cause]
	    end
  	end
end