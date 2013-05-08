require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('KkokKio') }
    it { should have_title(full_title('')) }
    it { should_not have_title('|') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:post, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:post, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      it { should have_link("Users", href: users_path) }
      it { should have_link("Favorites", href: favorites_user_path(user)) }

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

      # describe "follow/unfollow buttons" do
      #   let(:other_user) { FactoryGirl.create(:user) }
      #   before { sign_in user }

      #   describe "following a user" do
      #     before { visit user_path(other_user) }

      #     it "should increment the followed user count" do
      #       expect do
      #         click_button "Follow"
      #       end.to change(user.followed_users, :count).by(1)
      #     end

      #     it "should increment the other user's followers count" do
      #       expect do
      #         click_button "Follow"
      #       end.to change(other_user.followers, :count).by(1)
      #     end

      #     describe "toggling the button" do
      #       before { click_button "Follow" }
      #       it { should have_xpath("//input[@value='Unfollow']") }
      #     end
      #   end

      #   describe "unfollowing a user" do
      #     before do
      #       user.follow!(other_user)
      #       visit user_path(other_user)
      #     end

      #     it "should decrement the followed user count" do
      #       expect do
      #         click_button "Unfollow"
      #       end.to change(user.followed_users, :count).by(-1)
      #     end

      #     it "should decrement the other user's followers count" do
      #       expect do
      #         click_button "Unfollow"
      #       end.to change(other_user.followers, :count).by(-1)
      #     end

      #     describe "toggling the button" do
      #       before { click_button "Unfollow" }
      #       it { should have_xpath("//input[@value='Follow']") }
      #     end
      #   end
      # end
    end
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title(full_title('About')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title(full_title('Contact'))}
  end
end
