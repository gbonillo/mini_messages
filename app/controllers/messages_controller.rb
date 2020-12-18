class MessagesController < ApplicationController
  before_action :require_login
  before_action :set_message, only: [:destroy] # :edit, :update,
  before_action :check_and_prepare_reply, only: [:reply_new, :reply_create]

  # GET /messages
  # GET /messages.json
  def index
    @is_thread = false
    if params["view"] && params["view"] == "thread"
      @is_thread = true
      @messages = Message.all
        .eager_load(:author, :dest)
        .is_root
        .visible(current_user)
        .order(created_at: "desc")
    else
      @messages = Message.all
        .eager_load(:author, :dest)
        .visible(current_user)
        .order(created_at: "desc")
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.eager_load(:author, :dest).find(params[:id])
    @message.load_all_tree_replies_visible(current_user)
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # POST /messages
  # POST /messages.json
  def create
    begin
      @message = Message.new(message_params)

      respond_to do |format|
        if @message.save
          format.html { redirect_to @message, notice: "Message was successfully created." }
          format.json { render :show, status: :created, location: @message }
        else
          format.html { render :new }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    rescue
      respond_to do |format|
        e = "Bad request!"
        format.html { redirect_to root_url, flash: { alert: e } } # halts request cycle
        format.json { render json: { error: e }, status: :unprocessable_entity }
      end
    end
  end

  # GET /messages/:id/reply/new
  def reply_new
    @message = Message.new
    @message.parent_message = @parent_message
  end

  # POST /messages/:id/reply
  # POST /messages/:id/reply.json
  def reply_create
    @parent_message = Message.find(params[:id])
    @message = Message.new(message_params(true))
    @message.parent_message = @parent_message

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :reply_new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def check_and_prepare_reply
    @parent_message = Message.find(params[:id])
    unless current_user && current_user.id == @parent_message.dest_id
      respond_to do |format|
        e = "You can't reply to this message (you're not the recipient!)"
        format.html { redirect_to root_url, flash: { alert: e } } # halts request cycle
        format.json { render json: { error: e }, status: :unauthorized }
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def message_params(is_reply = false)
    attrs = [:content]
    attrs += [:user_id, :dest_id, :is_public]
    params.require(:message).permit(*attrs)
  end
end
