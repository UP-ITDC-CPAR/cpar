module Officer::IssuesHelper
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
