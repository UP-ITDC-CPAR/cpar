class Activity < ActiveRecord::Base
  attr_accessible :actual_date, :result, :target_date, :status_id

  belongs_to :action_plan
  belongs_to :user
  validates :action_plan_id, presence: true
  validates :user_id, presence: true
end
