class Api::V1::AgentInteractionsController < ApplicationController
  def index
    @interactions = AgentInteraction.includes(:source_agent, :target _agent)
                                   .order(created_at: :desc)
                                   .limit(100)
    render json: @interactions
  end

  def show
    @interaction = AgentInteraction.find(params[:id])
    render json: @interaction
  end
end
