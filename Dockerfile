# for production

FROM ruby:2.7.5
ENV RUBYOPT -EUTF-8
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y nodejs yarn

RUN mkdir /shiori
WORKDIR /shiori
COPY Gemfile /shiori/Gemfile
COPY Gemfile.lock /shiori/Gemfile.lock
COPY . /shiori
RUN mkdir -p tmp/sockets

RUN bundle install
ARG ARG_RAILS_MASTER_KEY
ARG ARG_DATABASE_PASSWORD

RUN RAILS_ENV=production \
    RAILS_MASTER_KEY=$ARG_RAILS_MASTER_KEY \
    DATABASE_PASSWORD=$ARG_DATABASE_PASSWORD \
    bundle exec rake assets:precompile

CMD bundle exec puma -C config/puma.rb
