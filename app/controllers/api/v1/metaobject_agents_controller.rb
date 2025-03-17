class Api::V1::MetaobjectAgentsController < ApplicationController
  def index
    @agents = MetaobjectAgent.all
    render json: @agents
  end

  def show
    @agent = MetaobjectAgent.find(params[:id])
    render json: @agent.as_json(include: :agent_tools)
  end

  def invoke
    agent_handle = params[:handle]
    action_name = params[:action_name]
    payload = params[:payload]

    result = AgentService.invoke(agent_handle, action_name, payload)
    render json: { success: true, result: result }
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  def sync
    SyncAgentsJob.perform_later
    render json: { success: true, message: "Agent synchronization started" }
  end
end
