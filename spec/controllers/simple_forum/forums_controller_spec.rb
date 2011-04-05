require 'spec_helper'

describe SimpleForum::ForumsController do
  render_views

  subject { Factory(:forum) }

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
      get :show, :id => subject.to_param
      response.should be_success
      response.should render_template('show')
    end
  end


end