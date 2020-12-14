FROM ruby:2.7.2

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

EXPOSE 3000

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# comnand to start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

# add node deb repo
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
# add yarn deb repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
   echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# 
RUN apt-get update \
   && apt remove -y cmdtest \
   && apt-get install -y --no-install-recommends \
   postgresql-client \
   nodejs \
   yarn \
   && rm -rf /var/lib/apt/lists/*

#COPY Gemfile* /usr/src/app/
#RUN bundle install
COPY . /usr/src/app
