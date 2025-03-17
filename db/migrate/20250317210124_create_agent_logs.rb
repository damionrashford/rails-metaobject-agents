class CreateAgentLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :agent_logs do |t|
      t.references :metaobject_agent, null: true, foreign_key: true
      t.string :level
      t.text :message
      t.jsonb :details

      t.timestamps
    end
  end
end
