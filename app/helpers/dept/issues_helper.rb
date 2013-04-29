module Dept::IssuesHelper
	def found_dept(issue)
		found_dep=false
		if issue.department_id == current_user.department_id
			found_dep = true
		else
			@nrds = NextResponsibleDepartment.where("issue_id = ?", issue.id)
    		@nrds.each do |n|
      			if n.department_id == current_user.department_id
        			found_dep = true
      			end
    		end
		end
		found_dep
	end

	def found_officer_id(issue)
    found = false
    if issue.responsible_officer_id && issue.responsible_officer_id == current_user.id
      found = true
    else
      issue.next_responsible_departments.each do |nrd|
        if nrd.responsible_officer_id && nrd.responsible_officer_id == current_user.id
          found = true
        end
      end
    end
    found
  end
end
