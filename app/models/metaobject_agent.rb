class MetaobjectAgent < ApplicationRecord
  has_many :agent_tools, dependent: :destroy
  has_many :agent_logs, dependent: :nullify

  # Define relationships for agent interactions
  has_many :outgoing_interactions, class_name: "AgentInteraction", foreign_key: "source_agent_id", dependent: :destroy
  has_many :incoming_interactions, class_name: "AgentInteraction", foreign_key: "target_agent_id", dependent: :destroy

  validates :shopify_id, presence: true, uniqueness: true
  validates :handle, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true
  validates :status, presence: true
end
