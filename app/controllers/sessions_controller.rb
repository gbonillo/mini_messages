class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      reset_session
      log_in user
      respond_to do |format|
        format.html { redirect_to user_path(user, :html) }
        format.json { redirect_to user_path(user, :json) }
      end
    else
      flash.now[:alert] = "Invalid email/password combination"
      respond_to do |format|
        format.html { render :new, format: "html" }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
