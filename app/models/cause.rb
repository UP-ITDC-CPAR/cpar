class Cause < ActiveRecord::Base
  attr_accessible :date_issued, :description
  has_many :cause_comments, dependent: :destroy
  has_many :cause_attachments, dependent: :destroy
  belongs_to :issue
  belongs_to :user
  validates :issue_id, presence: true
  validates :user_id, presence: true
end
