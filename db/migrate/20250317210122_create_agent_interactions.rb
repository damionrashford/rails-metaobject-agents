class CreateAgentInteractions < ActiveRecord::Migration[7.0]
  def change
    create_table :agent_interactions do |t|
      t.references :source_agent, null: false, foreign_key: { to_table: :metaobject_agents }
      t.references :target_agent, null: false, foreign_key: { to_table: :metaobject_agents }
      t.string :action
      t.jsonb :payload
      t.jsonb :response
      t.string :status
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
