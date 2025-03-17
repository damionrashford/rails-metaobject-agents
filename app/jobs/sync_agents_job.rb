# app/jobs/sync_agents_job.rb
class SyncAgentsJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info("Starting agent synchronization")

    # Fetch agent references from Shopify
    agent_ids = ShopifyMetaobjectService.fetch_agent_references

    # Update or create agents in the database
    agent_ids.each do |agent_id|
      sync_agent(agent_id)
    end

    # Fetch system settings
    sync_system_settings

    # Log completion
    Rails.logger.info("Agent synchronization completed")
  end

  private

  def sync_agent(shopify_id)
    # Fetch detailed agent data
    agent_data = ShopifyMetaobjectService.fetch_agent(shopify_id)

    # Find or create the agent
    agent = MetaobjectAgent.find_or_initialize_by(shopify_id: agent_data[:id])
    agent.update!(
      handle: agent_data[:handle],
      name: agent_data[:name],
      role: agent_data[:role],
      status: agent_data[:status],
      instructions: agent_data[:instructions],
      api_config: agent_data[:api_config]
    )

    # Sync agent tools
    sync_agent_tools(agent, agent_data[:tools])

    agent
  end

  def sync_agent_tools(agent, tools)
    # Remove old tools that are no longer present
    current_tool_names = tools.map { |t| t["name"] }
    agent.agent_tools.where.not(name: current_tool_names).destroy_all

    # Update or create tools
    tools.each do |tool_data|
      tool = agent.agent_tools.find_or_initialize_by(name: tool_data["name"])
      tool.update!(
        description: tool_data["description"],
        tool_type: tool_data["type"],
        parameters: tool_data["parameters"],
        target_agent: tool_data["target_agent"],
        function_logic: tool_data["function_logic"],
        function_type: tool_data["function_type"]
      )
    end
  end

  def sync_system_settings
    # Fetch system settings from Shopify
    settings_data = ShopifyMetaobjectService.fetch_system_settings

    # Update or create settings
    settings_data.each do |key, value|
      setting = SystemSetting.find_or_initialize_by(key: key.to_s)
      setting.update!(
        value: value.to_s,
        description: "Imported from Shopify system_settings metaobject"
      )
    end
  end
end
