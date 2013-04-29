class NextResponsibleDepartment < ActiveRecord::Base
  attr_accessible :department_id, :dept_status_id, :issue_id, :responsibility_level, :responsible_officer_id
  belongs_to :issue
  validates :department_id, presence: true
end
