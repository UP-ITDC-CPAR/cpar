class IssueAttachment < ActiveRecord::Base
  attr_accessible :description, :issue_id, :myfile, :user_id
  belongs_to :user
  belongs_to :issue
  mount_uploader :myfile, MyfileUploader
end
