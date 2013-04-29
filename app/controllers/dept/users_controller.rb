class Dept::UsersController < ApplicationController
  before_filter :signed_in_user
  before_filter :dept_user

  def index
    if params[:sort] != nil
      if params[:sort] == '1'
        @users = User.where("department_id = " + current_user.department_id.to_s + " AND type_id = 3").paginate(page: params[:page], per_page: 10)
      end
    else
    	@users = User.where("department_id = " + current_user.department_id.to_s).paginate(page: params[:page], per_page: 10)
    end
  end
  #Add - Designate user for Changing to Responsible Officer
  #       *Must be Employee

  def show
  	@user = User.find(params[:id])
  end

  private
  def dept_user
      redirect_to(root_path) unless current_user.type_id==2
  end
end
