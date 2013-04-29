class ActivitiesController < ApplicationController
  before_filter :signed_in_user

  def show
    @activity=Activity.find(params[:id])
  end

end