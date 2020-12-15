class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def require_login
    unless logged_in?
      respond_to
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_url # halts request cycle
    end
  end

  def require_admin
    unless is_admin?
      flash[:error] = "You are not allowed here"
      redirect_to root_url # halts request cycle
    end
  end

  def require_self_or_admin(user)
    unless is_admin? || logged_in? && user&.id == current_user&.id
      respond_to
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_url # halts request cycle
    end
  end
end
