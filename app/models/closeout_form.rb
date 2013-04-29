class CloseoutForm < ActiveRecord::Base
  attr_accessible :auditor_id, :closeout_date, :completed, :issue_id, :qmr_id
  belongs_to :issue
  has_many :closeout_form_depts
end
