module SimpleForum
  class TopicsController < ::SimpleForum::ApplicationController
    respond_to :html

    before_filter :authenticate_user, :only => [:new, :create, :open, :close]

    before_filter :find_forum
    before_filter :find_topic, :except => [:index, :new, :create]
    before_filter :build_topic, :only => [:new, :create]

    before_filter :moderator_required, :only => [:open, :close]

    def index

      respond_to do |format|
        format.html do
          redirect_to simple_forum.forum_url(@forum), :status => :moved_permanently
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
            flash[:notice] = t('simple_forum.controllers.topics.topic_created')
            redirect_to simple_forum.forum_topic_url(@forum, @topic)
          else
            flash.now[:alert] = @topic.errors.full_messages.join(' ')
            render :new
          end
        end
      end
    end

    def open
      success = if @topic.is_open?
                  false
                else
                  @topic.open!
                  true
                end

      respond_to do |format|
        format.html do
          if success
            redirect_to :back, :notice => t('simple_forum.controllers.topics.topic_opened')
          else
            redirect_to :back, :alert => t('simple_forum.controllers.topics.topic_already_opened')
          end
        end
      end
    end

    def close
      success = if @topic.is_open?
                  @topic.close!
                  true
                else
                  false
                end

      respond_to do |format|
        format.html do
          if success
            redirect_to :back, :notice => t('simple_forum.controllers.topics.topic_closed')
          else
            redirect_to :back, :alert => t('simple_forum.controllers.topics.topic_already_closed')
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
      @topic = @forum.topics.new params[:topic] do |topic|
        topic.user = authenticated_user
      end
    end

    def moderator_required
      redirect_to :back, :alert => t('simple_forum.controllers.you_are_not_permitted_to_perform_this_action') unless @forum.moderated_by?(authenticated_user)
    end

  end
end
