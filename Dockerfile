FROM ruby:2.6.3
ENV RUBYOPT -EUTF-8
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y nodejs yarn

RUN mkdir /shiori
WORKDIR /shiori
ADD Gemfile /shiori/Gemfile
ADD Gemfile.lock /shiori/Gemfile.lock
ADD . /shiori
