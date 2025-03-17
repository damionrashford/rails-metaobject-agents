class AddIndexesToTables < ActiveRecord::Migration[7.0]
  def change
    add_index :metaobject_agents, :shopify_id, unique: true
    add_index :metaobject_agents, :handle, unique: true
    add_index :agent_tools, [ :metaobject_agent_id, :name ], unique: true
    add_index :agent_interactions, [ :source_agent_id, :target_agent_id, :created_at ],
              name: 'index_agent_interactions_composite'
    add_index :agent_logs, [ :metaobject_agent_id, :level, :created_at ],
              name: 'index_agent_logs_composite'
    add_index :system_settings, :key, unique: true
  end
end
