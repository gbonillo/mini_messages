module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    if @current_user
      @current_user
    elsif session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def is_admin?
    logged_in? && current_user&.is_admin?
  end

  def is_current_user?(user)
    !user.nil? && logged_in? && !current_user&.nil? && current_user.id == user.id
  end

  # Logs out the current user.
  def log_out
    reset_session
    @current_user = nil
  end
end
