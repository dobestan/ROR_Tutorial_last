require 'spec_helper'

describe "StaticPages" do

  # Home Page
  describe "Home Page" do
    it "should repond to http get" do
      get static_pages_home_path
      response.status.should be 200
    end

    it "should have the title 'Home'" do
      visit "/static_pages/home"
      expect(page).to have_title('Home')
    end

    it "should have the base title" do
      visit "/static_pages/home"
      expect(page).to have_title "Ruby on Rails Tutorial Sample App"
    end
  end

  # Help Page
  describe "Help Page" do
    it "should respond to http get" do
      get static_pages_help_path
      response.status.should be 200
    end

    it "should have the title 'Help'" do
      visit "/static_pages/help"
      expect(page).to have_title "Help"
    end

    it "should have the base title" do
      visit "/static_pages/help"
      expect(page).to have_title "Ruby on Rails Tutorial Sample App"
    end
  end

  # About Page
  describe "About Page" do
    it "should respond to http get" do
      get static_pages_about_path
      response.status.should be 200
    end

    it "should have the title 'About'" do
      visit "/static_pages/about"
      expect(page).to have_title "About"
    end

    it "should have the base title" do
      visit "/static_pages/about"
      expect(page).to have_title "Ruby on Rails Tutorial Sample App"
    end
  end

end
