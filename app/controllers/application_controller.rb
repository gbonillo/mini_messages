class ApplicationController < ActionController::Base
  include SessionsHelper

  #
  # vulnérabilité potentielle
  # @todo meilleure authentification pour l'API !
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  private

  #
  # on permet l'acces à l'API par Basic auth
  # @bof
  # @todo : une vrai method d'authenfication dans une vrai appli API REST !
  #
  def _http_basic_authenticate
    case request.format
    when Mime[:json]
      user = authenticate_with_http_basic do |u, p|
        #byebug
        User.find_and_authenticate(u, p)
      end
      if user
        @current_user = user
      else
        @current_user = nil
        #request_http_basic_authentication
      end
    else
      # !noop
    end
  end

  #
  # Piste pour CSRF via API ?
  # on stocke le token en cookie pour permettre l'utilisation d'appel d'API
  # le header X-CSRF-TOKEN doit ensuite être fourni avec cette valeur pour une requete POST
  #
  # def set_csrf_cookie
  #   cookies["CSRF-TOKEN"] = form_authenticity_token
  # end

  def require_login
    _http_basic_authenticate unless logged_in?
    unless logged_in?
      respond_to do |format|
        e = "You must be logged in to access this section"
        format.html { redirect_to login_url, flash: { alert: e } } # halts request cycle
        format.json { render(json: { error: e }, status: :unauthorized) }
      end
    end
  end

  def require_admin
    _http_basic_authenticate unless logged_in?
    unless is_admin?
      respond_to do |format|
        e = "You are not allowed here"
        format.html { redirect_to root_url, flash: { alert: e } } # halts request cycle
        format.json { render json: { error: e }, status: :unauthorized }
      end
    end
  end

  def require_self_or_admin(user)
    _http_basic_authenticate unless logged_in?
    unless is_admin? || logged_in? && user&.id == current_user&.id
      respond_to do |format|
        e = "You are not allowed here"
        format.html { redirect_to root_url, flash: { alert: e } } # halts request cycle
        format.json { render json: { error: e }, status: :unauthorized }
      end
    end
  end
end
