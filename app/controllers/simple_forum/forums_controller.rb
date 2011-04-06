module SimpleForum
  class ForumsController < ApplicationController
    respond_to :html

    before_filter :find_forum, :except => [:index]

    def index
      @forums = SimpleForum::Forum.default_order.includes({:recent_post => [:user, :topic]})

      respond_with(@forums)
    end

    def show
      @forum.bang_recent_activity(authenticated_user)

      scope = @forum.topics.includes([:user, {:recent_post => :user}])
      @topics = scope.respond_to?(:paginate) ? scope.paginate(:page => params[:page], :per_page => params[:per_page]) : scope.all

      respond_to :html
    end

    private

    def find_forum
      @forum = SimpleForum::Forum.find params[:id]
    end

  end
end