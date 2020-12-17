class SessionsController < ApplicationController
  before_action :check_not_logged_in, only: [:new, :create]
  before_action :check_logged_in, only: [:delete]

  def new
    respond_to do |format|
      format.html { render :new, format: "html" }
      format.json { render json: "OK", status: :ok }
    end
  end

  def create
    user = User.find_and_authenticate(params[:session][:email].downcase, params[:session][:password])
    if user
      reset_session
      log_in user
      respond_to do |format|
        format.html { redirect_to root_url(:html) }
        format.json { render json: "", status: :accepted }
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

  private

  def _redirect_to_root
    if condition
      respond_to do |format|
        format.html { redirect_to root_url(:html) }
        format.json { render json: "Are you sure ?", status: :bad_request }
      end
    end
  end

  def check_not_logged_in
    _redirect_to_root if logged_in?
  end

  def check_logged_in
    _redirect_to_root if !logged_in?
  end
end
