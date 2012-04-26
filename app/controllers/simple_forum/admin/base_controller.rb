module SimpleForum
  class Admin::BaseController < ::SimpleForum::ApplicationController
    layout 'simple_forum/admin'
    before_filter :forum_admin_required

    protected

  end

end



