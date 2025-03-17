# app/services/agent_service.rb
class AgentService
  class AgentError < StandardError; end

  def self.invoke(agent_handle, action_name, payload, context = nil)
    Agent::InvocationService.invoke(agent_handle, action_name, payload, context)
  end
end
