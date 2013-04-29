class StaticPagesController < ApplicationController
  def home
  	@issues = Issue.all
  	@issues_closed = Issue.where("final_closeout_date between ? and ?", Date.today.at_beginning_of_month, Date.today.next_month.beginning_of_month)
  	@issues_thismonth = Issue.where("created_at between ? and ?", Date.today.at_beginning_of_month, Date.today.next_month.beginning_of_month)
    @issues_pending = Issue.where("final_closeout_date is NULL").count #.sum(:total_price)
    @issues_rejected = Issue.where("status_id = 7").count
  	# can also use this format YourModel.where(:created_at => start_date..end_date)
  	@issues_total = Issue.all.count.to_f
  	
    if @issues_total != 0
      @issues_admin = Issue.where("department_id = 1").count / @issues_total
    	@issues_maintenance = Issue.where("department_id = 2").count / @issues_total
    	@issues_development = Issue.where("department_id = 3").count / @issues_total
    	@issues_verification = Issue.where("department_id = 4").count / @issues_total
    else
      @issues_admin = 0
      @issues_maintenance = 0
      @issues_development = 0
      @issues_verification = 0
    end
    
    @average = 0
    @closed_issues = Issue.where("final_closeout_date is NOT NULL")
    @closed_issues.each do |i|
      @average += i.time_to_resolve
    end

    if @closed_issues.count == 0
      @average = 0
    else
      @average = @average / @closed_issues.count
    end
  end
end
