require 'spec_helper'

describe SimpleForum::ForumsController do
  include Devise::TestHelpers
  render_views

  before(:all) do
    @forum = Factory(:forum)
  end

  before(:each) do
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
      response.should render_template('index')
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get :show, :id => @forum.to_param
      response.should be_success
      response.should render_template('show')
    end
  end


end