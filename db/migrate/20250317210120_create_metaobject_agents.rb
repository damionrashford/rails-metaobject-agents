class CreateMetaobjectAgents < ActiveRecord::Migration[8.0]
  def change
    create_table :metaobject_agents do |t|
      t.string :shopify_id
      t.string :handle
      t.string :name
      t.string :role
      t.string :status
      t.text :instructions
      t.jsonb :api_config

      t.timestamps
    end
  end
end
