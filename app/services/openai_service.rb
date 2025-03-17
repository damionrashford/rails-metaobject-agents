# app/services/openai_service.rb
require "openai"

class OpenaiService
  def self.client
    @client ||= OpenAI::Client.new(
-----------
        ----------------
    )
  end

  def self.chat_completion(messages, tools = nil, tool_choice = nil)
    params = {
      model: ENV["OPENAI_MODEL"] || "gpt-4o",
      messages: messages,
      temperature: 0.3,
      max_tokens: 1000
    }

    # Add tools if provided
    if tools.present?
      params[:tools] = tools
      params[:tool_choice] = tool_choice || "auto"
    end

    # Add response format if needed
    if tools.blank? || tool_choice == "none"
      params[:response_format] = { type: "json_object" }
    end

    response = client.chat(parameters: params)

    # Process and return the response
    process_response(response)
  end

  private

  def self.process_response(response)
    message = response.dig("choices", 0, "message")
    return { error: "No message in response" } unless message

    if message["tool_calls"].present?
      # Process tool calls
      {
        tool_calls: message["tool_calls"].map do |tool_call|
          {
            id: tool_call["id"],
            name: tool_call.dig("function", "name"),
            arguments: JSON.parse(tool_call.dig("function", "arguments"))
          }
        end
      }
    elsif message["content"].present?
      # Process content
      begin
        JSON.parse(message["content"])
      rescue JSON::ParserError
        { content: message["content"] }
      end
    else
      { error: "Empty response" }
    end
  end
end
