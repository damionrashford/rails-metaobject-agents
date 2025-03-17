# app/services/shopify_api_service.rb
class ShopifyApiService
  def self.initialize_session
    ShopifyAPI::Context.setup(
      api_key: ENV["SHOPIFY_API_KEY"],
      api_secret_key: ENV["SHOPIFY_API_SECRET"],
      host: ENV["SHOPIFY_SHOP_DOMAIN"],
      scope: "read_products,write_products,read_customers,write_customers,read_orders,write_orders,read_inventory,write_inventory",
      is_private: true
    )

    ShopifyAPI::Auth::Session.new(
      shop: ENV["SHOPIFY_SHOP_DOMAIN"],
      access_token: ENV["SHOPIFY_ACCESS_TOKEN"]
    )
  end

  def self.graphql_request(query, variables = {})
    client = ShopifyAPI::Clients::Graphql::Private.new(
      session: initialize_session
    )

    response = client.query(query: query, variables: variables)

    if response.errors.present?
      Rails.logger.error("GraphQL Error: #{response.errors.inspect}")
      raise "GraphQL Error: #{response.errors.messages.join(', ')}"
    end

    response.body["data"]
  end
end
