require 'spec_helper'

describe Activity do

  let(:user) { User.create name: 'Nico Catajoy', phone: '5191568', mobile: '09173068540', 
                email: 'vnrcatajoy@gmail.com', 
                type_id: 1,
                department_id: 1, 
                password: 'password',
                password_confirmation: 'password' }
  before { @activity = user.activities.build(result: "Lorem ipsum") }

  subject { @activity }

  it { should respond_to(:result) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Activity.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @activity.user_id = nil }
    it { should_not be_valid }
  end
end