class Api::V1::AgentLogsController < ApplicationController
  def index
    @logs = AgentLog.includes(:metaobject_agent)
                   .order(created_at: :desc)
                   .limit(100)
    render json: @logs
  end
end
