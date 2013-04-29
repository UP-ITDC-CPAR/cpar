require 'spec_helper'

describe "Issues" do
  before do
    ##CREATE SAMPLE DATA

    #create default User Types
    UserType.create name: 'Administrator'
    UserType.create name: 'Customer'

    #create a default User
    user = User.create name: 'Nico Catajoy', phone: '5191568', mobile: '09173068540', 
                email: 'vnrcatajoy@gmail.com', 
                type_id: 1,
                password: 'password',
                password_confirmation: 'password',
                department_id: 1

    #make user admin
    user.admin = true
    user.save

    #create default Departments
    Department.create name: 'Administration'
    Department.create name: 'Maintainance'

    #create default Impact Types
    IssueImpact.create name: '1-Critical'
    IssueImpact.create name: '2-Major'
    IssueImpact.create name: '3-Minor'

    #create default Issue Status
    IssueStatus.create name: 'New'
    IssueStatus.create name: 'Investigating'
    IssueStatus.create name: 'Correcting'
    IssueStatus.create name: 'Closed'

    #create default Issue Types
    IssueType.create name: 'Process Related'
    IssueType.create name: 'KPI'
    IssueType.create name: 'Supplier Related'
    IssueType.create name: 'Top Priority'

    #create default ISO Non Conformance Types
    IsoNc.create title: '1A'
    IsoNc.create title: '1B'
    IsoNc.create title: '2A'
    IsoNc.create title: '2B'
    IsoNc.create title: '3A'
    IsoNc.create title: '3B'

    #create an issue with fixed params
    @issue = Issue.create title: 'ITDC Slow Internet Connection', description: 'Low Bandwidth', user_id: 1, 
                          impact_id: 1, status_id: 1, department_id: 1, type_id: 4, iso_nc_id: 5

    sign_in user
  end

  describe "view-all-issue page" do
    before do 
      # sign_in user
      visit issues_path
    end

    it "displays all issues with their title, originator name, impact and status" do      

      Issue.all.each do |issue|
        page.should have_content issue.title
        page.should have_content issue.user.name
        page.should have_content issue.issue_impact.name
        page.should have_content issue.issue_status.name
      end

    end
  end

  describe "new issue page" do
    before do
      # sign_in user
      visit issues_path
      click_link 'Report New Issue'
      current_path.should == new_issue_path
    end

    describe "with invalid information" do
      it "should not create a new issue with empty parameters" do
        click_button 'Create Issue'
        page.should have_content 'There was an error in creating your issue.'
        current_path.should == new_issue_path
      end
    end

    describe "with valid information" do
      it "creates a new issue" do    
        fill_in 'Title',          with: 'No projects'
        fill_in 'Description',    with: 'Lalala just going to test the description box'

        select 'Administration',  from: "Department"
        select 'KPI',             from: "Type"
        select '1-Critical',      from: "Impact"
        select 'New',             from: "Status"
        select '1A',          from: "ISO Reference ID"

        click_button 'Create Issue'

        current_path.should == issues_path

        page.should have_content 'The issue has been created!'

        page.should have_content 'No projects'
        page.should have_content 'Nico Catajoy'
        page.should have_content '1-Critical'
        page.should have_content 'New'

      end
    end
  end

  describe "show issue page" do
    before do
      visit issues_path
    end

    it "should show an issue" do
      find("#issue_#{@issue.id}").click_link 'Show'

      page.should have_content @issue.title
      page.should have_content @issue.description
      page.should have_content @issue.user.name
      page.should have_content @issue.user.email
      page.should have_content @issue.department.name
      page.should have_content @issue.issue_type.name
      page.should have_content @issue.issue_impact.name
      page.should have_content @issue.issue_status.name
      page.should have_content @issue.iso_nc.title

    end
  end
    
  describe "edit issue page" do
    before do 
      visit issues_path
    end

    it "should edit an issue" do
      find("#issue_#{@issue.id}").click_link 'Edit'

      current_path.should == edit_issue_path(@issue)

      find_field('Title').value.should == @issue.title
      find_field('Description').value.should == @issue.description
      
      page.should have_content @issue.user.name
      page.should have_content @issue.user.email

      find_field('Department').find('option[selected]').text.should == @issue.department.name
      find_field('Impact').find('option[selected]').text.should == @issue.issue_impact.name
      find_field('Status').find('option[selected]').text.should == @issue.issue_status.name
      find_field('Type').find('option[selected]').text.should == @issue.issue_type.name
      find_field('ISO Reference ID').find('option[selected]').text.should == @issue.iso_nc.title

      fill_in 'Title',  with: 'Internet connection is very slow'
      select '2-Major', from: 'Impact'
      select 'Investigating', from: 'Status'

      click_button 'Update Issue'

      current_path.should == issues_path

      page.should have_content 'The issue has been updated successfuly!'
      page.should have_content 'Internet connection is very slow'
      page.should have_content '2-Major'
      page.should have_content 'Investigating'

    end
  end

  describe "delete issue page" do
    before do 
      visit issues_path
    end

    it "should delete an issue" do
      find("#issue_#{@issue.id}").click_link 'Delete'
      page.should have_content 'The issue was successfuly deleted.'
      page.should have_no_content 'Internet connection is very slow'

    end
  end

end
