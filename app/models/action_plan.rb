class ActionPlan < ActiveRecord::Base
  attr_accessible :description, :final_review_date, :final_implementation_review_date, :issue_id, :ap_status_id
  validates :description, presence: true
  has_many :activities, dependent: :destroy
  has_many :action_plan_comments, dependent: :destroy
  belongs_to :action_plan_status, :foreign_key => 'ap_status_id', :class_name => 'ActionPlanStatus'
  # also has ap_reviewer_id and implementation_reviewer_id for its user_ids
  # also, issue_id, responsible_officer_id, approved and implemented booleans
  # approved = for Auditor to assign, implemented is for Responsible Officer
end
