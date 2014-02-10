require 'spec_helper'

describe "User Pages" do
  subject { page }
  describe "Sign in Page" do
    before { visit signup_path }

    it { should have_title "Sign up" }
    it { should have_content "Sign up" }
  end
  
end
