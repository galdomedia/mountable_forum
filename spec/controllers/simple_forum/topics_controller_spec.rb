require 'spec_helper'

describe SimpleForum::TopicsController do
  render_views

  subject {
    Factory(:topic)
  }

  before(:all) do
    @user = Factory(:user)
  end

  before(:each) do
    Factory(:topic, :forum => subject.forum, :user => @user)
  end

  describe "GET 'index'" do
    it "should redirect to topics#show" do
      get :index, :forum_id => subject.forum.to_param
      response.should redirect_to(simple_forum_forum_path(subject.forum))
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get :show, :forum_id => subject.forum.to_param, :id => subject.to_param
      response.should be_success
      response.should render_template('show')
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new, :forum_id => subject.forum.to_param
      response.should be_success
      response.should render_template('new')
    end
  end

  context "for signed in user" do
    before(:each) do

    end

    describe "POST 'create'" do
      describe "with valid params" do
        it "should redirect to topic" do
          post :create, :forum_id => subject.forum.to_param, :topic => Factory.attributes_for(:topic)
          response.should redirect_to(simple_forum_forum_topic_path(subject.forum, assigns(:topic)))
        end
      end

      describe "with invalid params" do
        it "should render template 'new'" do
          post :create, :forum_id => subject.forum.to_param, :topic => Factory.attributes_for(:topic).inject({}) { |h, (k, v)| h[k] = nil; h }
          response.should render_template('new')
        end
      end
    end
  end


end