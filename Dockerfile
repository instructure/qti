FROM instructure/rvm

USER root

RUN apt-get update && apt-get install -y unzip \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8
WORKDIR /app

COPY qti.gemspec Gemfile /app/
COPY lib/qti/version.rb /app/lib/qti/version.rb

USER root
RUN mkdir -p /app/coverage \
             /app/spec/gemfiles/.bundle \
 && chown -R docker:docker /app

USER docker
RUN /bin/bash -l -c "cd /app && rvm-exec 2.3 bundle install --jobs 5"
RUN /bin/bash -l -c "cd /app && rvm-exec 2.4 bundle install --jobs 5"
RUN /bin/bash -l -c "cd /app && rvm-exec 2.5 bundle install --jobs 5"
COPY . /app

USER root
RUN chown -R docker:docker /app
USER docker

CMD /bin/bash -l -c "rvm-exec 2.5 bundle exec wwtd"