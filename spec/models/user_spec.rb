require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should respond_to(:remember_token)}
  it { should respond_to(:authenticate)}

  it { should respond_to(:admin)}

  it { should be_valid }
  it { should_not be_admin }

  describe "User with admin attribute" do
    before do 
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "User Name" do
    describe "when name is not present" do
      before { @user.name = " " }
      it { should_not be_valid }
    end

    describe "when name is too long" do
      before { @user.name = "a" * 51 }
      it { should_not be_valid }
    end
  end

  describe "User Email" do
    describe "when email is not present" do
      before { @user.email = " " }
      it { should_not be_valid }
    end

    describe "when email is too long" do
      before { @user.email = "a" * 51 }
      it { should_not be_valid }
    end

    describe "Email Validation" do
      context "when email format is invalid" do
        it "should be invalid" do
          emails = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar foo@bar+baz.com]
          emails.each do |invalid_email|
            @user.email = invalid_email
            expect(@user).not_to be_valid
          end
        end
      end

      context "when email format is valid" do
        it "should be valid" do
          emails = %w[user@foo.com first.last@foo.jp a+b@baz.cn]
          emails.each do |valid_email|
            @user.email = valid_email
            expect(@user).to be_valid
          end
        end
      end

      context "when email is already taken" do
        before do
          user_with_same_email = @user.dup
          user_with_same_email.email = @user.email.upcase
          user_with_same_email.save
        end

        it { should_not be_valid }
      end
    end
  end

  describe "User Password" do
    describe "when password is not present" do
      before do
        @user = User.new(name: "Example User", email: "user@example.com", password: " ", password_confirmation: " ")
      end

      it { should_not be_valid }
    end

    describe "when password is too short" do
      before do
        @user.password = "a"*5
        @user.password_confirmation = "a"*5
      end

      it { should be_invalid }
    end

    describe "return value of authenticate method" do
      before do
        @user.save
      end
      let(:found_user) { User.find_by(email: @user.email ) }

      context "with valid password" do
        it { should eq found_user.authenticate(@user.password)}
      end

      context "with invalid password" do
        let(:user_for_invalid_password) { found_user.authenticate("invalid") }

        it { should_not eq user_for_invalid_password }
        specify { expect(user_for_invalid_password).to be_false }
      end
    end
  end

  describe "remember token" do
    before { @user.save }

    its(:remember_token) { should_not be_blank }
  end
end
