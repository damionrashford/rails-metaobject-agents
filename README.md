# Rails Metaobject Agents

A Rails application for managing Shopify metaobject-based AI agents.

## System Overview

This system provides a management layer for AI agents defined as metaobjects in Shopify. It includes:

- Agent synchronization from Shopify metaobjects
- Agent invocation and coordination
- Distributed locking for concurrent operations
- Caching for performance optimization
- Background job processing
- API endpoints for agent management

## Setup

### Prerequisites

- Ruby 3.4.2
- PostgreSQL
- Redis
- Memcached

### Installation

1. Clone the repository
   ```
   git clone https://github.com/yourusername/rails-metaobject-agents.git
   cd rails-metaobject-agents
   ```

2. Install dependencies
   ```
   bundle install
   ```

3. Set up environment variables
   ```
   cp .env.example .env
   # Edit .env with your credentials
   ```

4. Create and migrate the database
   ```
   rails db:create db:migrate db:seed
   ```

5. Start the services
   ```
   # Start PostgreSQL
   brew services start postgresql@14
   
   # Start Redis
   brew services start redis
   
   # Start Memcached
   brew services start memcached
   ```

6. Start the Rails server
   ```
   rails server
   ```

7. Start Sidekiq for background jobs
   ```
   bundle exec sidekiq
   ```

## System Architecture

### Models

- **MetaobjectAgent**: Represents an AI agent defined in Shopify
- **AgentTool**: Represents a tool/action that an agent can perform
- **AgentInteraction**: Records interactions between agents
- **AgentLog**: Logs agent activities and errors
- **SystemSetting**: Stores system-wide configuration

### Services

- **MemcachedService**: Handles caching and distributed locking
- **PubSubService**: Manages asynchronous messaging between components
- **ShopifyMetaobjectService**: Interfaces with Shopify metaobjects
- **AgentService**: Core service for agent invocation and coordination

### API Endpoints

- `GET /api/v1/metaobject_agents`: List all agents
- `GET /api/v1/metaobject_agents/:id`: Get agent details
- `POST /api/v1/metaobject_agents/invoke`: Invoke an agent action
- `POST /api/v1/metaobject_agents/sync`: Trigger agent synchronization
- `GET /api/v1/agent_interactions`: List agent interactions
- `GET /api/v1/system_settings`: Get system settings
- `PUT /api/v1/system_settings/:key`: Update a system setting
- `GET /api/v1/agent_logs`: View agent logs
- `GET /health`: Health check endpoint

## Development with Docker

For development with Docker:

```
docker-compose up
```

This will start PostgreSQL, Redis, Memcached, Rails, and Sidekiq containers.

## Deployment

### Kubernetes Deployment

The application can be deployed to Kubernetes:

```
bin/deploy
```

This script builds the Docker image and applies the Kubernetes configurations.

## Testing

Run the test suite:

```
bundle exec rspec
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.