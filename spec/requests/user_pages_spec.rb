require 'spec_helper'

describe "User Pages" do
  subject { page }
  let(:admin) { FactoryGirl.create(:user, admin: true) }

  describe "Index Page" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_title "All Users" }
    it { should have_content "All Users" }

    describe "delete action" do
      it { should_not have_link "delete" }

      describe "login as admin user" do
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link "delele" }
        it "should be able to delete another user" do
          expect do
            click_link("delete", match: :first)
          end.to change(User, :count).by(-1)
        end

        it { should_not have_link("delete", user_path(admin)) }
      end
    end

    describe "paginate" do
      before(:all) do
        30.times { FactoryGirl.create(:user) }
      end

      after(:all) do
        User.delete_all
      end

      it { should have_selector "div.pagination" }

      it "should list each user by paginate" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name )
        end
      end
    end
  end

  describe "Sign in Page" do 
    before { visit signup_path }

    it { should have_title "Sign up" }
    it { should have_content "Sign up" }
  end

  describe "Profile Page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path user }

    it { should have_content user.name }
    it { should have_content user.email }
  end

  describe "Sign Up Page" do
    before { visit signup_path }

    let(:submit) { "Create my Account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: "user@example.com")}

        it { should have_link("Sign out", href: signout_path) }
        it { should have_title user.name }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content "Update your profile" }
      it { should have_title "Edit user" }
      it { should have_link("change", href: "http://gravatar.com/emails")}
    end

    describe "with invalid informations" do
      before { click_button "Save changes" }

      it { should have_content "error" }
    end

    describe "with valid informations" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }

      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end

      it { should have_title new_name }
      it { should have_link("Sign out", href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end
