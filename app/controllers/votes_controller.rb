# app/controllers/votes_controller.rb
class VotesController < ApplicationController
  def create
    option = Option.find(params[:option_id])
    poll = option.poll

    vote = Vote.find_or_initialize_by(poll: poll, user_uid: params[:user_uid])
    previous_option = vote.option

    ActiveRecord::Base.transaction do
      if vote.persisted? && previous_option
        previous_option.decrement!(:votes_count)
      end

      if vote.new_record?
        option.increment!(:votes_count)
      elsif previous_option != option
        option.increment!(:votes_count)
      end

      vote.update!(option: option)
    end

    # Garantir ordem consistente
    updated_options = poll.options.order(id: :asc).map do |opt|
      {
        id: opt.id,
        content: opt.content,
        votes_count: opt.votes_count,
        created_at: opt.created_at
      }
    end

    ActionCable.server.broadcast("poll_#{poll.token}", updated_options)
    head :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Opção inválida" }, status: :not_found
  end

  def check_vote
    vote = Vote.find_by(poll_id: Poll.find_by(token: params[:token]), user_uid: params[:user_uid])
    render json: { voted: vote.present?, option_id: vote&.option_id }
  end
end
