FROM ruby:3.2

# Set the working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy the entire app
COPY . .

# Expose the application port
EXPOSE 3000

# Start the server
CMD ["rails", "server", "-b", "0.0.0.0"]
