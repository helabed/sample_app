require 'spec_helper'

describe "Users" do
  
  describe "signup" do

    describe "success" do

      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
    
    describe "failure" do
    
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end
  end

  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in" do
        user = Factory(:user)
        user.email, user.password = '', ''
        integration_sign_in user
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        integration_sign_in user
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end

  describe "delete link" do
    it "should show 'delete' link for admins" do
      user = Factory(:user, :admin => true)
      integration_sign_in user
      visit users_path
      response.should have_selector("a", :content => "delete")
    end

    it "should not show 'delete' link for non-admins" do
      user = Factory(:user, :admin => false)
      integration_sign_in user
      visit users_path
      response.should_not have_selector("a", :content => "delete")
    end
  end
end
