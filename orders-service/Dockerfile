FROM public.ecr.aws/sam/build-ruby3.3 AS base

COPY src/Gemfile* .

RUN gem install bundler:2.5.22 && \
  bundle config set --local path 'vendor/bundle' && \
  bundle install

COPY src/function.rb src/orders_service.rb .
COPY src/orders_service orders_service

FROM base AS dist
RUN zip -r orders-service.zip Gemfile* function.rb orders_service.rb orders_service vendor

CMD "/bin/bash"
