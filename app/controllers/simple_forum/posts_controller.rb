module SimpleForum
  class PostsController < ApplicationController

    before_filter :authenticate_user, :except => [:index, :show]

    before_filter :find_forum
    before_filter :find_topic
    before_filter :find_post, :except => [:index, :new, :create]
    before_filter :build_post, :only => [:new, :create]
    before_filter :post_must_be_editable_by_authenticate_user, :only => [:edit, :update]

    def index

      respond_to do |format|
        format.html do
          redirect_to simple_forum_forum_topic_url(@forum, @topic), :status => :moved_permanently
        end
      end
    end

    def show

      respond_to do |format|
        format.html { redirect_to simple_forum_forum_topic_url(@forum, @topic, :page => @post.on_page, :anchor => "post-#{@post.id}") }
      end
    end

    def create
      success = @post.save

      respond_to do |format|
        format.html do
          if success
            redirect_to simple_forum_forum_topic_url(@forum, @topic, :page => @post.on_page, :anchor => "post-#{@post.id}"),
                        :notice => t('simple_forum.controllers.posts.post_created')
          else
            redirect_to simple_forum_forum_topic_url(@forum, @topic, :page => @topic.last_page, :anchor => (@topic.recent_post ? "post-#{@topic.recent_post.id}" : nil)),
                        :alert => @post.errors.full_messages.join(', ')
          end
        end
      end
    end

#    def preview
#      @post = SimpleForum::Post.new(params[:post]) do |post|
#        post.user = authenticated_user
#        post.created_at, post.updated_at = Time.now
#      end
#
#      respond_with(@post) do |format|
#        format.js { render :layout => false }
#        format.html { render :layout => 'simple' }
#      end
#    end

    def edit

      respond_to :html
    end

    def update
      @post.edited_by = authenticated_user
      @post.edited_at = Time.now
      success = @post.update_attributes(params[:post])

      respond_to do |format|
        format.html do
          if success
            redirect_to simple_forum_forum_topic_url(@forum, @topic, :page => @post.on_page, :anchor => "post-#{@post.id}"),
                        :notice => t('simple_forum.controllers.posts.post_updated')
          else
            redirect_to :back, :alert => @post.errors.full_messages.join(', ')
          end
        end
      end
    end


    def delete
      success = @post.mark_as_deleted_by(authenticated_user) #check if post is deletable by authenticated_user in mark_as_deleted_by method

      respond_to do |format|
        format.html do
          if success
            redirect_to :back, :notice => t('simple_forum.controllers.posts.post_deleted')
          else
            redirect_to :back, :alert => t('simple_forum.controllers.posts.post_cant_be_deleted')
          end
        end
      end
    end

    private

    def find_forum
      @forum = SimpleForum::Forum.find params[:forum_id]
    end

    def find_topic
      @topic = @forum.topics.find params[:topic_id]
    end

    def find_post
      @post = @topic.posts.find params[:id]
    end

    def build_post
      @post = @topic.posts.new params[:post] do |post|
        post.user = authenticated_user
      end
    end

    def post_must_be_editable_by_authenticate_user
      redirect_to :back, :alert => t('simple_forum.controllers.posts.post_cant_be_edited') unless @post.editable_by?(authenticated_user, nil)
    end

  end
end