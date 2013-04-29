class ActionPlanComment < ActiveRecord::Base
  attr_accessible :action_plan_id, :content, :user_id #:log_comment, protected
  belongs_to :action_plan

  validates :content, presence: true
  validates :action_plan_id, presence: true

  default_scope order: 'action_plan_comments.created_at DESC'
end
