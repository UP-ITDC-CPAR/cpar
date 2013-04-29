class CauseComment < ActiveRecord::Base
  attr_accessible :cause_id, :content, :user_id #, :log_comment protected
  belongs_to :cause
  validates :content, presence: true
  validates :cause_id, presence: true

  default_scope order: 'cause_comments.created_at DESC'
end