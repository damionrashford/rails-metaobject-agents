class AgentTool < ApplicationRecord
  belongs_to :metaobject_agent

  validates :name, presence: true
  validates :tool_type, presence: true
end
