module SimpleForum
  module Admin
    class ForumsController < ::SimpleForum::Admin::BaseController

      def search_users
        user_class = instance_eval(&SimpleForum.invoke(:user_class))
        @users = user_class.where(["#{user_class.quoted_table_name}.email LIKE ?", "%#{params[:user_name_like].to_s.gsub(/[\%\_]/) { |m| "\\#{m}" }}%"]).limit(16)

        respond_to do |format|
          format.json do
            render :json => @users.inject({}) { |hash, u| hash[u.id] = u.name; hash }
          end
        end
      end

      def index
        @categories = SimpleForum::Category.default_order.includes({:forums => [{:recent_post => [:user, :topic]}, :moderators]})

        @forums = SimpleForum::Forum.default_order.includes({:recent_post => [:user, :topic]}, :moderators)
        @forums_by_category = @categories.inject(ActiveSupport::OrderedHash.new) { |h, c| h[c] = []; h }
        @forums.each do |f|
          (@forums_by_category[@categories.detect { |c| c.try(:id) == f.category_id }] ||= []) << f
        end
        @forums_by_category.reject! { |c, forums| forums.blank? }

        respond_with(@forums)
      end

      def show

        respond_with([:admin, resource])
      end

      def edit

        respond_with([:admin, resource])
      end

      def new

        respond_with([:admin, resource])
      end

      def create
        success = resource.save

        respond_with([:admin, resource]) do |format|
          format.html do
            if success
              redirect_to [:admin, resource]
            else
              render :new
            end
          end
        end
      end

      def update
        success = resource.update_attributes(params[:forum])

        respond_with([:admin, resource]) do |format|
          format.html do
            if success
              redirect_to [:admin, resource]
            else
              render :edit
            end
          end
        end
      end

      def destroy
        resource.destroy

        respond_with([:admin, resource])
      end

      private

      def resource
        @forum ||= params[:id] ? SimpleForum::Forum.find(params[:id]) : SimpleForum::Forum.new(params[:forum])
      end

      helper_method :resource

    end
  end
end
