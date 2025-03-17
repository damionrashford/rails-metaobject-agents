FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Expose port
EXPOSE 3000

# Start the application
CMD ["rails", "server", "-b", "0.0.0.0"]