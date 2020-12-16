class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def require_login
    unless logged_in?
      respond_to do |format|
        e = "You must be logged in to access this section"
        format.html { redirect_to login_url, flash: { alert: e } } # halts request cycle
        format.json { render json: { error: e }, status: :unauthorized }
      end
    end
  end

  def require_admin
    unless is_admin?
      respond_to do |format|
        e = "You are not allowed here"
        format.html { redirect_to root_url, flash: { alert: e } } # halts request cycle
        format.json { render json: { error: e }, status: :unauthorized }
      end
    end
  end

  def require_self_or_admin(user)
    unless is_admin? || logged_in? && user&.id == current_user&.id
      respond_to do |format|
        e = "You are not allowed here"
        format.html { redirect_to root_url, flash: { alert: e } } # halts request cycle
        format.json { render json: { error: e }, status: :unauthorized }
      end
    end
  end
end
