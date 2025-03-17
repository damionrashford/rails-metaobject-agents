# app/services/agent/ai_processing_service.rb
module Agent
  class AiProcessingService
    def self.process_request(agent, action_name, payload, context = nil)
      # Get the system context
      system_context = ShopifyMetaobjectService.fetch_system_context rescue "Enterprise-level Shopify store with AI agents."

      # Get the agent's instructions
      instructions = agent.instructions

      # Get the agent's tools
      tools = agent.agent_tools.map do |tool|
        {
          type: "function",
          function: {
            name: tool.name,
            description: tool.description,
            parameters: tool.parameters
          }
        }
      end

      # Prepare messages for the AI
      messages = [
        { role: "system", content: "#{instructions}\n\nSystem Context: #{system_context}" }
      ]

      # Add context if provided
      if context.present?
        messages << { role: "user", content: context }
      end

      # Add the current request
      messages << {
        role: "user",
        content: "Action: #{action_name}\nPayload: #{payload.to_json}"
      }

      # Call OpenAI
      response = OpenaiService.chat_completion(messages, tools.presence)

      # Process the response
      if response[:tool_calls].present?
        # Execute the tool calls
        tool_results = response[:tool_calls].map do |tool_call|
          tool_name = tool_call[:name]
          tool_args = tool_call[:arguments]

          # Find the tool
          tool = agent.agent_tools.find_by(name: tool_name)
          if tool.present?
            # Execute the tool
            result = ToolExecutionService.process_tool_action(agent, tool, tool_args, {})
            { tool: tool_name, result: result }
          else
            { tool: tool_name, error: "Tool not found" }
          end
        end

        # Return the results
        { tool_results: tool_results }
      else
        # Return the content directly
        response
      end
    end
  end
end
