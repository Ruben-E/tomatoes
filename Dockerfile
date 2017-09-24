FROM ruby:2.3.3-alpine 

ENV RAILS_ROOT /app
ENV RACK_ENV production 

# Install dependencies
RUN apk --update add --virtual build-dependencies ruby-dev build-base

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

# Gems:
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN gem install bundler --no-ri --no-rdoc
RUN bundle install --without development test
RUN apk del build-dependencies

# Copy the main application.
ADD . .

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb