class CauseAttachment < ActiveRecord::Base
  attr_accessible :cause_id, :description, :myfile, :user_id
  belongs_to :user
  belongs_to :cause
  mount_uploader :myfile, MyfileUploader
end
