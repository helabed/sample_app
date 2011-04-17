require 'spec_helper'

describe "Microposts" do

  before(:each) do
    user = Factory(:user)
    integration_sign_in(user)
  end

  describe "creation" do

    describe "failure" do

      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end

    describe "success" do

      it "should make a new micropost" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("span.content", :content => content)
          # Test pluralization here, for a single post
          response.should have_selector("span.microposts", :content => "1 micropost\n")
        end.should change(Micropost, :count).by(1)
      end

      it "should pluralize microposts" do
        content1 = "Lorem ipsum dolor sit amet"
        content2 = "my wonderful content"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content1
          click_button
          response.should have_selector("span.content", :content => content1)
          fill_in :micropost_content, :with => content2
          click_button
          response.should have_selector("span.content", :content => content2)
          response.should have_selector("span.microposts", :content => "2 microposts")
        end.should change(Micropost, :count).by(2)
      end

      it "should paginate microposts" do
        lambda do
          visit root_path
          (1..40).each do |num|
            content = "my wonderful content item #{num}"
            fill_in :micropost_content, :with => content
            click_button
            response.should have_selector("span.content", :content => content)
          end
          response.should have_selector("span.microposts", :content => "40 microposts")
          response.should have_selector("div.pagination>a.next_page", :content => "Next")
          click_link "Next"
          response.should have_selector("div.pagination>a.previous_page", :content => "Previous")
          click_link "Previous"
          response.should have_selector("div.pagination>a.next_page", :content => "Next")
        end.should change(Micropost, :count).by(40)
      end
    end
  end

  describe "micropost delete link" do

    it "should show 'delete' link for current_user" do
      visit root_path
      content = "my wonderful content item"
      fill_in :micropost_content, :with => content
      click_button
      response.should have_selector("a", :content => "delete")
    end

    it "should not show 'delete' link for different user" do
      visit root_path
      content = "my wonderful content item"
      fill_in :micropost_content, :with => content
      click_button
      wrong_user = Factory(:user, :email => 'user@example.net')
      integration_sign_in wrong_user
      visit root_path
      response.should_not have_selector("a", :content => "delete")
    end
  end
end
