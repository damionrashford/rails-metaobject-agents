Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :metaobject_agents, only: [ :index, :show ] do
        collection do
          post :invoke
          post :sync
        end

        # Add member routes for individual agent operations
        member do
          get :tools
          post :test_tool
        end
      end

      resources :agent_interactions, only: [ :index, :show ] do
        collection do
          get :recent
          get :by_agent/:agent_id, to: "agent_interactions#by_agent", as: :by_agent
        end
      end

      resources :system_settings, only: [ :index, :update ]

      resources :agent_logs, only: [ :index ] do
        collection do
          get :errors
          get :by_agent/:agent_id, to: "agent_logs#by_agent", as: :by_agent
        end
      end

      # System-wide operations
      namespace :system do
        post :sync_agents
        get :status
        post :test_agent
        get :system_context
      end
    end
  end

  # Sidekiq web UI (protected in production)
  if Rails.env.development?
    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq"
  end

  # Health check endpoint
  get "health", to: "health#index"

  # Root route
  root to: "health#index"
end
