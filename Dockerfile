FROM instructure/rvm

ENV LANG C.UTF-8
WORKDIR /app

USER root
RUN apt-get update && apt-get install -y unzip \
 && apt-get clean && rm -rf /var/lib/apt/lists/* \
 && chown -R docker:docker /app
USER docker

COPY --chown=docker:docker qti.gemspec Gemfile /app/
COPY --chown=docker:docker lib/qti/version.rb /app/lib/qti/version.rb

RUN mkdir -p /app/coverage \
             /app/spec/gemfiles/.bundle

RUN bash -lc "rvm 2.7,3.0,3.1 do gem install --no-document bundler -v '~> 2.4.22'"
RUN bash -lc "rvm 2.7,3.0,3.1 do bundle install --jobs 5"
COPY --chown=docker:docker . /app

CMD bash -lc "rvm-exec 2.7 bundle exec wwtd"
