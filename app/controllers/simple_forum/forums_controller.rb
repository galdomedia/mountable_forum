module SimpleForum
  class ForumsController < ApplicationController
    respond_to :html

    before_filter :find_forum, :except => [:index]

    def index
      @forums = SimpleForum::Forum.default_order.all

      respond_with(@forums)
    end

    def show
#    bang_recent_activity(@forum)
      @topics = @forum.topics.paginate :page => params[:page], :per_page => params[:per_page]

      respond_to :html
    end

    private

    def find_forum
      @forum = SimpleForum::Forum.find params[:id]
    end

  end
end