FROM ruby:3.4.2

RUN groupadd --system ruby && \
    useradd --system --create-home --gid ruby ruby && \
    mkdir -p /usr/src/app && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      dumb-init \
      libjemalloc2 \
      && \
    rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8

WORKDIR /usr/src/app

EXPOSE 3000
ENV PORT 3000
ENV APP_DIR /usr/src/app

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
ENV MALLOC_CONF=dirty_decay_ms:1000,narenas:2,background_thread:true

ENV RUBY_YJIT_ENABLE=1

COPY Gemfile* /usr/src/app/
RUN gem install bundler && bundle install
COPY . /usr/src/app
RUN chown -R ruby:ruby /usr/src/app

USER ruby

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]
CMD [ "/usr/src/app/web_start.sh" ]
