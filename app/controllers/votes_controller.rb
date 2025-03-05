# app/controllers/votes_controller.rb
class VotesController < ApplicationController
  def create
    option = Option.find(params[:option_id])
    option.update!(votes: option.votes || 0 + 1)

    # Broadcast via Action Cable
    ActionCable.server.broadcast("poll_#{params[:token]}", option.poll.options)

    head :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Opção inválida" }, status: :not_found
  end
end