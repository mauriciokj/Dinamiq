class PollChannel < ApplicationCable::Channel
  def subscribed
    poll = Poll.find_by(token: params[:token])
    stream_from "poll_#{params[:token]}" if poll
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
