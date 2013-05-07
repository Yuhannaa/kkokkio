require 'spec_helper'

describe Favorite do

  let(:favorer) { FactoryGirl.create(:user) }
  let(:favorite_post) { FactoryGirl.create(:post, user: FactoryGirl.create(:user)) }
  let(:favorite) { favorer.favorites.build(post_id: favorite_post.id) }

  subject { favorite }

  it { should be_valid }

  describe "favorite methods" do    
    it { should respond_to(:user) }
    it { should respond_to(:post) }
    its(:user) { should eql(favorer) }
    its(:post) { should eql(favorite_post) }
  end

  describe "when user id is not present" do
    before { favorite.user_id = nil }
    it { should_not be_valid }
  end

  describe "when post id is not present" do
    before { favorite.post_id = nil }
    it { should_not be_valid }
  end
end
