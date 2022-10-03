FROM ruby:2.7.5-slim as ruby_builder

RUN apt-get update -qq && \
  apt-get install -y build-essential git-core libpq-dev awscli postgresql-client && \
  apt-get -y clean

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN gem install --clear-sources bundler -v 2.3.21
RUN bundle install

# Add a script to be executed every time the container starts.

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
