module SimpleForum
  class TopicsController < ApplicationController
    respond_to :html

    before_filter :authenticate_user, :only => [:new, :create]

    before_filter :find_forum
    before_filter :find_topic, :except => [:index, :new, :create]
    before_filter :build_topic, :only => [:new, :create]

    def index

      respond_to do |format|
        format.html do
          redirect_to simple_forum_forum_path(@forum), :status => :moved_permanently
        end
      end
    end

    def show
      @topic.bang_recent_activity(authenticated_user)
      @topic.increment_views_count

      @posts_search = @topic.posts.includes([:user, :deleted_by, :edited_by])
      @posts = @posts_search.respond_to?(:paginate) ?
          @posts_search.paginate(:page => params[:page], :per_page => params[:per_page] || SimpleForum::Post.per_page) :
          @posts_search.all

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
            redirect_to simple_forum_forum_topic_url(@forum, @topic)
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
        topic.user = authenticated_user
      end
    end

  end
end