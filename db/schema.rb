# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_17_210521) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "agent_interactions", force: :cascade do |t|
    t.bigint "source_agent_id", null: false
    t.bigint "target_agent_id", null: false
    t.string "action"
    t.jsonb "payload"
    t.jsonb "response"
    t.string "status"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_agent_id", "target_agent_id", "created_at"], name: "index_agent_interactions_composite"
    t.index ["source_agent_id"], name: "index_agent_interactions_on_source_agent_id"
    t.index ["target_agent_id"], name: "index_agent_interactions_on_target_agent_id"
  end

  create_table "agent_logs", force: :cascade do |t|
    t.bigint "metaobject_agent_id"
    t.string "level"
    t.text "message"
    t.jsonb "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metaobject_agent_id", "level", "created_at"], name: "index_agent_logs_composite"
    t.index ["metaobject_agent_id"], name: "index_agent_logs_on_metaobject_agent_id"
  end

  create_table "agent_tools", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "tool_type"
    t.jsonb "parameters"
    t.string "target_agent"
    t.text "function_logic"
    t.string "function_type"
    t.bigint "metaobject_agent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metaobject_agent_id", "name"], name: "index_agent_tools_on_metaobject_agent_id_and_name", unique: true
    t.index ["metaobject_agent_id"], name: "index_agent_tools_on_metaobject_agent_id"
  end

  create_table "metaobject_agents", force: :cascade do |t|
    t.string "shopify_id"
    t.string "handle"
    t.string "name"
    t.string "role"
    t.string "status"
    t.text "instructions"
    t.jsonb "api_config"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["handle"], name: "index_metaobject_agents_on_handle", unique: true
    t.index ["shopify_id"], name: "index_metaobject_agents_on_shopify_id", unique: true
  end

  create_table "system_settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_system_settings_on_key", unique: true
  end

  add_foreign_key "agent_interactions", "metaobject_agents", column: "source_agent_id"
  add_foreign_key "agent_interactions", "metaobject_agents", column: "target_agent_id"
  add_foreign_key "agent_logs", "metaobject_agents"
  add_foreign_key "agent_tools", "metaobject_agents"
end
