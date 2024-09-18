# Base image with Ruby
ARG RUBY_VERSION=3.2.0
FROM ruby:$RUBY_VERSION

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    nodejs \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /rails

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Expose port and start server
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

