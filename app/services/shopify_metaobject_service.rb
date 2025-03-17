# app/services/shopify_metaobject_service.rb
class ShopifyMetaobjectService
  def self.fetch_system_context
    MemcachedService.cache("system_context", ttl: 3600) do
      query = <<~GRAPHQL
        {
          shop {
            systemContextMetafield: metafield(namespace: "global", key: "system_context") {
              value
            }
          }
        }
      GRAPHQL

      result = ShopifyApiService.graphql_request(query)
      result.dig("shop", "systemContextMetafield", "value")
    end
  end

  def self.fetch_agent_references
    MemcachedService.cache("agent_references", ttl: 1800) do
      query = <<~GRAPHQL
        {
          shop {
            agentReferencesMetafield: metafield(namespace: "ai_agents", key: "agent_references") {
              value
            }
          }
        }
      GRAPHQL

      result = ShopifyApiService.graphql_request(query)
      JSON.parse(result.dig("shop", "agentReferencesMetafield", "value"))
    end
  end

  def self.fetch_agent(metaobject_id)
    MemcachedService.cache("agent:#{metaobject_id}", ttl: 600) do
      query = <<~GRAPHQL
        {
          metaobject(id: "#{metaobject_id}") {
            id
            handle
            type
            displayName
            nameField: field(key: "name") {
              value
            }
            roleField: field(key: "role") {
              value
            }
            statusField: field(key: "status") {
              value
            }
            instructionsField: field(key: "instructions") {
              value
            }
            toolsField: field(key: "tools") {
              value
            }
            apiConfigField: field(key: "api_configuration") {
              value
            }
          }
        }
      GRAPHQL

      result = ShopifyApiService.graphql_request(query)
      metaobject = result["metaobject"]

      {
        id: metaobject["id"],
        handle: metaobject["handle"],
        name: metaobject.dig("nameField", "value"),
        role: metaobject.dig("roleField", "value"),
        status: metaobject.dig("statusField", "value"),
        instructions: metaobject.dig("instructionsField", "value"),
        tools: JSON.parse(metaobject.dig("toolsField", "value") || "[]"),
        api_config: JSON.parse(metaobject.dig("apiConfigField", "value") || "{}")
      }
    end
  end

  def self.fetch_system_settings
    MemcachedService.cache("system_settings", ttl: 600) do
      query = <<~GRAPHQL
        {
          metaobjects(type: "system_settings", first: 1) {
            edges {
              node {
                id
                handle
                defaultTimeoutField: field(key: "default_timeout") {
                  value
                }
                maxRetriesField: field(key: "max_retries") {
                  value
                }
              }
            }
          }
        }
      GRAPHQL

      result = ShopifyApiService.graphql_request(query)
      metaobject = result.dig("metaobjects", "edges", 0, "node")

      {
        default_timeout: metaobject.dig("defaultTimeoutField", "value").to_i,
        max_retries: metaobject.dig("maxRetriesField", "value").to_i
      }
    end
  end
end
