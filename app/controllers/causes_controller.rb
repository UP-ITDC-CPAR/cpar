class CausesController < ApplicationController
  before_filter :signed_in_user

  def show
    @cause=Cause.find(params[:id])
    @cause_comment = CauseComment.new
    @cause_comments = @cause.cause_comments.where(log_comment: 'f').paginate(page: params[:page],  per_page: 3)
    @cause_updates = @cause.cause_comments.where(log_comment: 't').paginate(page: params[:page],  per_page: 5)
  end

  #add filter later like in public issues controller, to limit who 
  #could view Issue/Causes page, same for Action Plan

end
