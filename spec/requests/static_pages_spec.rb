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

      describe "favorite/undo favorite buttons" do
        let(:other_user) { FactoryGirl.create(:user) }
        let!(:favorite_post) { FactoryGirl.create(:post, user: other_user) }
        before do
          user.follow!(other_user)
          visit root_path
        end

        describe "favoriting a post" do
          it "should increment the user's favorite posts count" do
            expect do
              page.first(".favorite-btn").click
            end.to change(user.favorite_posts, :count).by(1)
          end

          it "should increment the post's favorers count" do
            expect do
              page.first(".favorite-btn").click
            end.to change(favorite_post.favorers, :count).by(1)
          end

          describe "toggling the button" do
            before { page.first(".favorite-btn").click }
            it { should have_xpath("//input[@value='Favorited']") }
          end
        end

        describe "undoing favorite a post" do
          before do
            user.favorite!(favorite_post)
            visit root_path
          end

          it "should decrement the user's favorite posts count" do
            expect do
              click_button "Favorited"
            end.to change(user.favorite_posts, :count).by(-1)
          end

          it "should decrement the post's favorers count" do
            expect do
              click_button "Favorited"
            end.to change(favorite_post.favorers, :count).by(-1)
          end

          describe "toggling the button" do
            before { click_button "Favorited" }
            it { should have_xpath("//input[@value='Favorite']") }
          end
        end
      end
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
