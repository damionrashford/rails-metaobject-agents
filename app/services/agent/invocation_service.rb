# app/services/agent/invocation_service.rb
module Agent
  class InvocationService
    def self.invoke(agent_handle, action_name, payload, context = nil)
      agent = MetaobjectAgent.find_by(handle: agent_handle)
      raise AgentService::AgentError, "Agent not found: #{agent_handle}" unless agent

      # Log the invocation
      log = AgentLog.create!(
        metaobject_agent: agent,
        level: "info",
        message: "Invoking action: #{action_name}",
        details: { payload: payload }
      )

      # Use distributed locking to prevent concurrent modifications
      MemcachedService.with_lock("agent:#{agent.shopify_id}", ttl: 30) do
        # Get system settings
        system_settings = SystemSetting.pluck(:key, :value).to_h

        # Find the tool for this action
        tool = AgentTool.find_by(metaobject_agent: agent, name: action_name)

        # Process the request
        result = if tool.present?
          # Process using the specific tool
          ToolExecutionService.process_tool_action(agent, tool, payload, system_settings)
        else
          # Process using AI with the agent's configuration
          AiProcessingService.process_request(agent, action_name, payload, context)
        end

        # Log the interaction if it's an agent-to-agent action
        if tool&.tool_type == "agent_action" && tool&.target_agent.present?
          target_agent = MetaobjectAgent.find_by(handle: tool.target_agent)
          if target_agent
            AgentInteraction.create!(
              source_agent: agent,
              target_agent: target_agent,
              action: action_name,
              payload: payload,
              response: result,
              status: "completed",
              started_at: log.created_at,
              completed_at: Time.current
            )
          end
        end

        # Update the log with the result
        log.update!(
          level: "info",
          message: "Action completed: #{action_name}",
          details: log.details.merge(result: result)
        )

        # Publish event for other agents
        PubSubService.publish("agent.actions", {
          agent_id: agent.shopify_id,
          agent_handle: agent.handle,
          action: action_name,
          result: result,
          timestamp: Time.current.iso8601
        })

        result
      end
    rescue => e
      # Log the error
      AgentLog.create!(
        metaobject_agent: agent,
        level: "error",
        message: "Error invoking action: #{action_name}",
        details: {
          payload: payload,
          error: e.message,
          backtrace: e.backtrace&.first(10)
        }
      )

      raise
    end
  end
end
