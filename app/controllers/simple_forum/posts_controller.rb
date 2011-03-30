module SimpleForum
  class TopicsController < ApplicationController

    before_filter :find_forum
    before_filter :find_topic
    before_filter :find_post, :except => [:index, :new, :create]
    before_filter :build_post, :only => [:new, :create]

    def show

      respond_to do |format|
        format.html { redirect_to forum_topic_url(@forum, @topic, :page => @post.on_page, :anchor => @template.dom_id(@post)) }
      end
    end

    def create
      success = @post.save

      respond_to do |format|
        format.html do
          if success
            redirect_to forum_post_path(@post),
                        :notice => t('controllers.forum.posts.post_created')
          else
            redirect_to forum_topic_path(@form, @topic, :page => @topic.last_page, :anchor => (@topic.recent_post ? @template.dom_id(@topic.recent_post) : nil)),
                        :alert => @post.errors.full_messages.join(', ')
          end
        end
      end
    end

    def preview
      @post = Forum::Post.new(params[:forum_post]) do |post|
        post.user = current_user
        post.created_at, post.updated_at = Time.now
      end

      respond_with(@post) do |format|
        format.js { render :layout => false }
        format.html { render :layout => 'simple' }
      end
    end

    private

    def find_forum
      @topic = SimpleForum.find params[:forum_id]
    end

    def find_topic
      @topic = @forum.topics.find params[:topic_id]
    end

    def find_post
      @topic.posts.find params[:id]
    end

    def build_post
      @post = @topic.posts.new params[:simple_forum_posts] do |post|
        post.user = current_user
      end
    end

  end
end