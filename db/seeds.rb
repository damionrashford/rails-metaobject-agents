# Create system settings
SystemSetting.find_or_create_by(key: 'default_timeout') do |setting|
  setting.value = '10'
  setting.description = 'Default timeout in seconds for agent operations'
end

SystemSetting.find_or_create_by(key: 'max_retries') do |setting|
  setting.value = '3'
  setting.description = 'Maximum number of retry attempts for failed operations'
end

# Create a test agent if in development environment
if Rails.env.development?
  test_agent = MetaobjectAgent.find_or_create_by(shopify_id: 'gid://shopify/Metaobject/test') do |agent|
    agent.handle = 'test-agent'
    agent.name = 'Test Agent'
    agent.role = 'Testing'
    agent.status = 'Online'
    agent.instructions = 'This is a test agent for development purposes.'
    agent.api_config = {
      name: 'Test API',
      model: 'test-model',
      temperature: 0.3
    }
  end

  # Create a test tool
  AgentTool.find_or_create_by(metaobject_agent: test_agent, name: 'test_action') do |tool|
    tool.description = 'A test action'
    tool.tool_type = 'shopify'
    tool.parameters = {
      type: 'object',
      properties: {
        test_param: {
          type: 'string',
          description: 'A test parameter'
        }
      },
      required: [ 'test_param' ]
    }
    tool.function_logic = 'function testAction(params) { return { success: true, params: params }; }'
    tool.function_type = 'JavaScript'
  end
end
