require 'spec_helper'

describe "StaticPages" do
  subject { page }

  # Home Page
  describe "Home Page" do
    before { visit root_path }

    it "should repond to http get" do
      get root_path 
      response.status.should be 200
    end

    it { should have_title('Home') }
    it { should have_title "Ruby on Rails Tutorial Sample App" }
  end

  # Help Page
  describe "Help Page" do
    before { visit help_path }

    it "should respond to http get" do
      get help_path 
      response.status.should be 200
    end

    it { should have_title('Help') }
    it { should have_title "Ruby on Rails Tutorial Sample App" }
  end

  # About Page
  describe "About Page" do
    before { visit about_path }

    it "should respond to http get" do
      get about_path
      response.status.should be 200
    end

    it { should have_title('About') }
    it { should have_title "Ruby on Rails Tutorial Sample App" }
  end
end
