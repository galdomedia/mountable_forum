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
    @back_url = request.env['HTTP_REFERER'] = "http://back.pl"
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


    describe "GET 'edit'" do
      context "with id own post posted less than #{SimpleForum.minutes_for_edit_post} minutes ago" do
        it "should render template 'edit'" do
          get :edit, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param
          response.should render_template(:edit)
        end
      end

      context "with id own post posted more than #{SimpleForum.minutes_for_edit_post} minutes ago" do
        before(:each) do
          @old_post = Factory(:post, :topic => @topic, :user => @user, :created_at => Time.now - (SimpleForum.minutes_for_edit_post.minutes + 10.minutes))
        end
        it "should redirect back and set flash['alert']" do
          get :edit, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @old_post.to_param
          flash[:notice].should be_blank
          flash[:alert].should_not be_blank
          response.should redirect_to(@back_url)
        end
      end

      context "with id another user's post posted less than #{SimpleForum.minutes_for_edit_post} minutes ago" do
        before(:each) do
          sign_in(Factory(:user))
        end
        it "should redirect back and set flash['alert']" do
          get :edit, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param
          flash[:notice].should be_blank
          flash[:alert].should_not be_blank
          response.should redirect_to(@back_url)
        end
      end

      context "with id another user's post when signed in as forum moderator" do
        before(:each) do
          @moderator = Factory(:user)
          @forum.moderators = [@moderator]
          sign_in(@moderator)
        end
        it "should render template 'edit'" do
          get :edit, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param
          response.should render_template(:edit)
        end
      end
    end
    describe "PUT 'update'" do
      context "with id own post posted less than #{SimpleForum.minutes_for_edit_post} minutes ago and valid params" do
        it "should redirect to topic last page with post anchor and set flash[:notice]" do
          put :update, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param, :post => Factory.attributes_for(:post)
          flash[:notice].should_not be_blank
          flash[:alert].should be_blank
          response.should redirect_to(simple_forum_forum_topic_path(@forum, @topic, :page => assigns(:post).on_page, :anchor => "post-#{assigns(:post).id}"))
        end
      end
    end

    describe "DELETE 'delete'" do
      context "with id own post posted less than #{SimpleForum.minutes_for_delete_post} minutes ago" do
        it "should redirect back and set flash[:notice]" do
          delete :delete, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param
          flash[:notice].should_not be_blank
          flash[:alert].should be_blank
          response.should redirect_to(@back_url)
        end
      end
      context "with id own post posted more than #{SimpleForum.minutes_for_delete_post} minutes ago" do
        before(:each) do
          @old_post = Factory(:post, :topic => @topic, :user => @user, :created_at => Time.now - (SimpleForum.minutes_for_delete_post.minutes + 10.minutes))
        end
        it "should redirect back and set flash['alert']" do
          delete :delete, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @old_post.to_param
          flash[:notice].should be_blank
          flash[:alert].should_not be_blank
          response.should redirect_to(@back_url)
        end
      end

      context "with id another user's post posted less than #{SimpleForum.minutes_for_delete_post} minutes ago" do
        before(:each) do
          sign_in(Factory(:user))
        end
        it "should redirect back and set flash[:alert]" do
          delete :delete, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param
          flash[:notice].should be_blank
          flash[:alert].should_not be_blank
          response.should redirect_to(@back_url)
        end
      end

      context "with id another user's post when signed in as forum moderator" do
        before(:each) do
          @forum.reload
          @moderator = Factory(:user)
          @forum.moderators = [@moderator]
          sign_in(@moderator)
        end
        it "should redirect back and set flash[:notice]" do
          delete :delete, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param
          flash[:notice].should_not be_blank
          flash[:alert].should be_blank
          response.should redirect_to(@back_url)
        end
      end
    end

    describe "GET 'preview'" do
      it "should respond with success" do
        request.accept = "text/javascript"
        get :preview, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :post => {:body => 'sdfdsf'}
        response.should be_success
      end
    end

  end

end