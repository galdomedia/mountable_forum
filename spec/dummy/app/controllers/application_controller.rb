class ApplicationController < ActionController::Base
  before_filter :set_locale

  protect_from_forgery

  def set_locale
    I18n.locale = :pl
  end


end
