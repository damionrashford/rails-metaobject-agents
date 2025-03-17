# app/services/agent/retry_service.rb
module Agent
  class RetryService
    def self.with_retries(max_retries, &block)
      retries = 0
      begin
        block.call
      rescue => e
        retries += 1
        if retries <= max_retries
          sleep(2 ** retries) # Exponential backoff
          retry
        else
          raise e
        end
      end
    end
  end
end
