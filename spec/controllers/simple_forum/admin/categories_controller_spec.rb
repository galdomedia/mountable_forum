require 'spec_helper'

describe SimpleForum::Admin::CategoriesController do
  before(:each) do
    @category = FactoryGirl.create(:category)
    @user = FactoryGirl.create(:admin)

    sign_in(@user)
  end

  describe "GET 'index'" do
    it "should be success" do
      get :index
      response.should be_success
      response.should render_template('index')
    end
  end

  describe "GET 'show'" do
    it "should be success" do
      get :show, :id => @category.to_param
      response.should be_success
      response.should render_template('show')
    end
  end

  describe "GET 'new'" do
    it "should be success" do
      get :new
      response.should be_success
      response.should render_template('new')
    end
  end

  describe "GET 'edit'" do
    it "should be success" do
      get :edit, :id => @category.to_param
      response.should be_success
      response.should render_template('edit')
    end
  end

  describe "POST 'create'" do
    context "with valid params" do
      it "should be redirected" do
        post :create, :category => FactoryGirl.attributes_for(:category)
        response.should redirect_to([:admin, assigns(:category)])
      end
    end
    context "with invalid params" do
      it "should render template 'new'" do
        post :create, :category => FactoryGirl.attributes_for(:category).inject({}) { |hash, (k, v)| hash[k] = ""; hash }
        response.should render_template('new')
      end
    end
  end

  describe "PUT 'update'" do
    context "with valid params" do
      it "should be redirected" do
        put :update, :id => @category.to_param, :category => FactoryGirl.attributes_for(:category)
        response.should redirect_to([:admin, assigns(:category)])
      end
    end
    context "with invalid params" do
      it "should render template 'edit'" do
        put :update, :id => @category.to_param, :category => FactoryGirl.attributes_for(:category).inject({}) { |hash, (k, v)| hash[k] = ""; hash }
        response.should render_template('edit')
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "should be redirected" do
      delete :destroy, :id => @category.to_param
      response.should redirect_to([:admin, :categories])
    end
  end

end