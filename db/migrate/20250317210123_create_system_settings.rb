class CreateSystemSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :system_settings do |t|
      t.string :key
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
