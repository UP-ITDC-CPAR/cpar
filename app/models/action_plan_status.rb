class ActionPlanStatus < ActiveRecord::Base
  has_many :action_plans

  attr_accessible :name
end
