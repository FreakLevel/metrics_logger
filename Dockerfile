FROM ruby:3.1.2
ENV RAILS_ENV=production

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y \
    build-essential nodejs yarn

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.3.15 && bundle install --jobs=4 --retry=3

COPY package.json ./
RUN yarn install --no-lockfile --non-interactive && yarn cache clean

COPY . ./

EXPOSE 3000
ENTRYPOINT ["./entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
