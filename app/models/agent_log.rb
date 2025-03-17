class AgentLog < ApplicationRecord
  belongs_to :metaobject_agent, optional: true

  validates :level, presence: true
  validates :message, presence: true
end
