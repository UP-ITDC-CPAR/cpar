class IssueComment < ActiveRecord::Base
  attr_accessible :content, :issue_id, :user_id #, :log_comment protected
  belongs_to :issue
  validates :content, presence: true
  validates :issue_id, presence: true

  default_scope order: 'issue_comments.created_at DESC'
end
