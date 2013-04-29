class CloseoutFormDept < ActiveRecord::Base
  attr_accessible :dept_head_id, :dept_id, :officer_id, :closeout_form_id
  belongs_to :closeout_form
  validates :dept_id, presence: true
end
