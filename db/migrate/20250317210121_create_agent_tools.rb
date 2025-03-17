class CreateAgentTools < ActiveRecord::Migration[8.0]
  def change
    create_table :agent_tools do |t|
      t.string :name
      t.string :description
      t.string :tool_type
      t.jsonb :parameters
      t.string :target_agent
      t.text :function_logic
      t.string :function_type
      t.references :metaobject_agent, null: false, foreign_key: true

      t.timestamps
    end
  end
end
