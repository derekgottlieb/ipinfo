FROM ruby:3.2.2

RUN groupadd --system ruby && \
    useradd --system --create-home --gid ruby ruby && \
    mkdir -p /usr/src/app && \
    apt-get update && \
    apt-get install -y dumb-init && \
    rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8

WORKDIR /usr/src/app

EXPOSE 3000
ENV PORT 3000
ENV APP_DIR /usr/src/app

COPY Gemfile* /usr/src/app/
RUN gem install bundler && bundle install
COPY . /usr/src/app
RUN chown -R ruby:ruby /usr/src/app

USER ruby

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]
CMD [ "/usr/src/app/web_start.sh" ]
