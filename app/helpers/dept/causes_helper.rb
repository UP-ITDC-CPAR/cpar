module Dept::CausesHelper
	def nrd_officer(issue)
		nrd_officer = false
		
		nrds = NextResponsibleDepartment.where("issue_id = ?", issue.id)
		nrds.each do |n|
			if n.responsible_officer_id == current_user.id
				nrd_officer = true
			end
		end
		nrd_officer
	end

	def main_officer(issue)
		main = false
		if issue.responsible_officer_id == current_user.id
			main = true
		end
		main
	end
end
