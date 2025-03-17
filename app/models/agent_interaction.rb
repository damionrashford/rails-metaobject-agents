class AgentInteraction < ApplicationRecord
  belongs_to :source_agent, class_name: "MetaobjectAgent"
  belongs_to :target_agent, class_name: "MetaobjectAgent"

  validates :action, presence: true
  validates :status, presence: true
end
