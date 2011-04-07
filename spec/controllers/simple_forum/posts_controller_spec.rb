require 'spec_helper'

describe SimpleForum::PostsController do
  include Devise::TestHelpers
  render_views

  before(:all) do
    @user = Factory(:user)
    @topic = Factory(:topic, :user => @user)
    @forum = @topic.forum
    @post = Factory(:post, :topic => @topic, :user => @user)
  end

  before(:each) do

  end

  describe "GET 'index'" do
    it "should redirect to topics#show" do
      get :index, :forum_id => @forum.to_param, :topic_id => @topic.to_param
      response.should redirect_to(simple_forum_forum_topic_path(@forum, @topic))
    end
  end

  describe "GET 'show'" do
    it "should redirect to topic last page with post anchor" do
      get :show, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param
      response.should redirect_to(simple_forum_forum_topic_path(@forum, @topic, :page => @post.on_page, :anchor => "post-#{@post.id}"))
    end
  end

  context "for signed in user" do
    before(:each) do
      sign_in(@user)
    end

    describe "POST 'create'" do
      describe "with valid params" do
        it "should redirect to topic last page with post anchor and set flash[:notice]" do
          post :create, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :post => Factory.attributes_for(:post)
          flash[:notice].should_not be_blank
          flash[:alert].should be_blank
          response.should redirect_to(simple_forum_forum_topic_path(@forum, @topic, :page => assigns(:post).on_page, :anchor => "post-#{assigns(:post).id}"))
        end
      end
      describe "with invalid params" do
        before(:each) do
          @topic.reload
        end
        it "should redirect to topic last page with recent post anchor and set flash[:alert]" do
          post :create, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :post => Factory.attributes_for(:post).inject({}) { |h, (k, v)| h[k] = nil; h }
          flash[:notice].should be_blank
          flash[:alert].should_not be_blank
          response.should redirect_to(simple_forum_forum_topic_url(@forum, @topic, :page => @topic.last_page, :anchor => (@topic.recent_post ? "post-#{@topic.recent_post.id}" : nil)))
        end
      end
    end
  end


end