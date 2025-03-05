# app/controllers/votes_controller.rb
class VotesController < ApplicationController
  def create
    logger.info "Parâmetros recebidos: #{params.inspect}"
    option = Option.find(params[:option_id])
    logger.info "Option antes do update: #{option.inspect}"
    
    option.update!(votes: (option.votes || 0) + 1)
    logger.info "Option depois do update: #{option.reload.inspect}"
    
    # Broadcast via Action Cable
    ActionCable.server.broadcast("poll_#{params[:token]}", option.poll.options)

    head :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Opção inválida" }, status: :not_found
  end
end