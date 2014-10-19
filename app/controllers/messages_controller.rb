class MessagesController < ApplicationController
  before_filter :set_classified, only: [:new, :create]

  def new
    @message = @classified.messages.build
  end

  def create
    @message = Message.new(message_params)
    @message.classified_id = params[:classified_id]
    if @message.save
      redirect_to classified_messages_path(@classified) and return
    else
      flash[:notice] = @message.errors
      render 'messages/new'
    end
  end

  def create_message
    @message = Message.new(message_params)
    @message.message_id = params[:message_id]

    if @message.save
      redirect_to messages_path, notice: "Your message has been sent"
    else
      flash[:notice] = @message.errors
      render 'messages/reply'
    end
  end

  def index
    @messages = current_member.classified_messages
    @outgoing = current_member.messages
  end

  def show
    set_message
  end

  def reply
    @message = Message.find(params[:message_id])
    @response = Message.new(message_id: params[:message_id])
  end

  def destroy
    set_message
    @message.destroy

    redirect_to messages_path, notice: "The message has been deleted!"
  end

  private

  def set_classified
    @classified = Classified.find(params[:classified_id])
  end

  def message_params
    params.require(:message).permit(:text).merge(member_id: current_member.id)
  end

  def set_message
    @message = Message.find(params[:id])
  end
end
