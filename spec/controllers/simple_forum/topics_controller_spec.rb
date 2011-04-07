require 'spec_helper'

describe SimpleForum::TopicsController do
  include Devise::TestHelpers
  render_views

  before(:all) do
    @user = Factory(:user)
    @topic = Factory(:topic, :user => @user)
    @forum = @topic.forum
  end

  before(:each) do

  end

  describe "GET 'index'" do
    it "should redirect to forums#show" do
      get :index, :forum_id => @forum.to_param
      response.should redirect_to(simple_forum_forum_path(@forum))
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get :show, :forum_id => @forum.to_param, :id => @topic.to_param
      response.should be_success
      response.should render_template('show')
    end
  end

  context "for signed in user" do
    before(:each) do
      sign_in(@user)
    end

    describe "GET 'new'" do
      it "should be successful" do
        get :new, :forum_id => @forum
        response.should be_success
        response.should render_template('new')
      end
    end

    describe "POST 'create'" do
      describe "with valid params" do
        it "should redirect to topic" do
          post :create, :forum_id => @forum.to_param, :topic => Factory.attributes_for(:topic)
          response.should redirect_to(simple_forum_forum_topic_path(@forum, assigns(:topic)))
        end
      end

      describe "with invalid params" do
        it "should render template 'new'" do
          post :create, :forum_id => @forum.to_param, :topic => Factory.attributes_for(:topic).inject({}) { |h, (k, v)| h[k] = nil; h }
          response.should render_template('new')
        end
      end
    end
  end


end