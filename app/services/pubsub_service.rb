require "google/cloud/pubsub"

class PubSubService
  def self.client
    @client ||= Google::Cloud::PubSub.new(project_id: ENV["GCP_PROJECT_ID"])
  end

  def self.publish(topic_name, message)
    return mock_publish(topic_name, message) unless gcp_configured?

    topic = client.topic(topic_name) || client.create_topic(topic_name)
    message_id = topic.publish(message.to_json)
    Rails.logger.info("Published message #{message_id} to topic #{topic_name}")
    message_id
  end

  def self.subscribe(subscription_name, topic_name, &block)
    return mock_subscribe(subscription_name, topic_name, &block) unless gcp_configured?

    topic = client.topic(topic_name) || client.create_topic(topic_name)
    subscription = topic.subscription(subscription_name) ||
                   topic.create_subscription(subscription_name)

    subscription.listen do |message|
      Rails.logger.info("Received message from #{topic_name}: #{message.message_id}")
      block.call(JSON.parse(message.data))
      message.acknowledge!
    end
  end

  private

  def self.gcp_configured?
    ENV["GCP_PROJECT_ID"].present?
  end

  # Mock implementations for local development
  def self.mock_publish(topic_name, message)
    Rails.logger.info("MOCK: Published message to topic #{topic_name}: #{message.to_json}")
    SecureRandom.uuid
  end

  def self.mock_subscribe(subscription_name, topic_name, &block)
    Rails.logger.info("MOCK: Subscribed to topic #{topic_name} with subscription #{subscription_name}")
    # In a real implementation, you might use a local queue system
  end
end
