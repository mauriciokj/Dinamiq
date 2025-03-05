# app/controllers/polls_controller.rb
class PollsController < ApplicationController
  def index
    polls = Poll.includes(:options).all
    render json: polls, include: :options
  end

  def create
    poll = Poll.new(poll_params)
    if poll.save
      render json: poll, status: :created
    else
      render json: { errors: poll.errors }, status: :unprocessable_entity
    end
  end

  def show
    poll = Poll.includes(:options).find_by!(token: params[:id])
    render json: poll, include: :options
  end

  private
  def poll_params
    params.require(:poll).permit(:title, options_attributes: [ :content ])
  end
end
