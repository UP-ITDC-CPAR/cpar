module Qmr::IssuesHelper
  def status_change(stat_id)
  	case stat_id
  	when 1
  		2
  	when 2
  		3
  	when 3
  		4	
  	when 4
  		5
  	else
  		5
  	end
  end

  def status_display(stat_id)
  	IssueStatus.find(stat_id+1).name
  end

  def closeoutform_finished(cof)
    finished = true
    # No need to check for Auditor id, because it's added as soon as COF is created,
    # along with CloseoutFormDepts and their corresponding Dept_ids
    cof.closeout_form_depts.each do |cofd|
      if cofd.dept_head_id == nil || cofd.officer_id == nil
        finished = false
      end
    end
    finished
  end
end
