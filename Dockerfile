FROM instructure/ruby:2.3

USER root

RUN apt-get update \
 && apt-get install -y unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8
WORKDIR /app

COPY Gemfile qti.gemspec Gemfile.lock /app/
RUN chown -R docker:docker /app

USER docker
RUN bundle install --jobs 8
USER root

COPY . /app
RUN mkdir -p /app/coverage && chown -R docker:docker /app

USER docker
