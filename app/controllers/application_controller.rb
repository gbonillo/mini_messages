class ApplicationController < ActionController::Base
  before_action :set_csrf_cookie
  include SessionsHelper

  private

  #
  # on stocke le token en cokkie pour permettre l'utilisation d'appel d'API
  # le header X-CSRF-TOKEN doit ensuite être fourni avec cette valeur pour une requete POST
  #
  def set_csrf_cookie
    cookies["CSRF-TOKEN"] = form_authenticity_token
  end

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
