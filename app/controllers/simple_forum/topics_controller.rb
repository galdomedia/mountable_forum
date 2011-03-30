module SimpleForum
  class TopicsController < ApplicationController
    respond_to :html

    before_filter :find_forum
    before_filter :find_topic, :except => [:index, :new, :create]
    before_filter :build_topic, :only => [:new, :create]

    def show
#    bang_recent_activity(@topic)
#    bang_recent_activity(@forum) 

      @posts_search = @topic.posts
      @posts = @posts_search.includes(:user).paginate :page => params[:page], :per_page => params[:per_page] || Forum::Post.per_page

      @post = SimpleForum::Post.new

      respond_with(@topic)
    end

    def new

      respond_with(@topic)
    end

    def create
      success = @topic.save

      respond_to do |format|
        format.html do
          if success
            flash[:notice] = t('controllers.forum.topics.topic_created')
            redirect_to forum_topic_url(@forum, @topic)
          else
            render :new
          end
        end
      end
    end

    private

    def find_forum
      @forum = SimpleForum::Forum.find params[:forum_id]
    end

    def find_topic
      @topic = @forum.topics.find params[:id]
    end

    def build_topic
      @topic = @forum.topics.new params[:simple_forum_topic] do |topic|
        topic.user = current_user
      end
    end

  end
end