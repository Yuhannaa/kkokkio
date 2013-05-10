require 'spec_helper'

describe FavoritesController do

  let(:user) { FactoryGirl.create(:user) }
  let!(:favorite_post) { FactoryGirl.create(:post, user: FactoryGirl.create(:user)) }

  before { session[:remember_token] = user.id }

  describe "creating a favorite with Ajax" do

    it "should increment the Favorite count" do
      expect do
        xhr :post, :create, favorite: { post_id: favorite_post.id }
      end.to change(Favorite, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, favorite: { post_id: favorite_post.id }
      expect(response).to be_success
    end
  end

  describe "destroying a favorite with Ajax" do

    before { user.favorite!(favorite_post) }
    let(:favorite) { user.favorites.find_by(post_id: favorite_post) }

    it "should decrement the Favorite count" do
      expect do
        xhr :delete, :destroy, id: favorite.id
      end.to change(Favorite, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: favorite.id
      expect(response).to be_success
    end
  end
end