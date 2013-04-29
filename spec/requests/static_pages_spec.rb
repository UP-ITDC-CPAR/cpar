require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "CPAR System -" }

  describe "Home page" do

    it "should have the h1 'CPAR System - Home'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'CPAR System - Home')
    end

    it "should have the title 'Home'" do
      visit '/static_pages/home'
      #page.should have_selector('title', :text => "CPAR System")
    end
  end
end
