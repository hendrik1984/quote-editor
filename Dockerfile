# Use the official Ruby image
FROM ruby:3.4.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Create app directory
RUN mkdir /app
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the application code
COPY . .

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]