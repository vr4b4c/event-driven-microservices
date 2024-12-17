FROM public.ecr.aws/sam/build-ruby3.3 AS base

FROM base AS dist
COPY src/Gemfile* .

RUN gem install bundler:2.5.22 && \
  bundle config set --local path 'vendor/bundle' && \
  bundle config set --local without 'development:test' && \
  bundle install

COPY src/function.rb src/reserve_inventory.rb .
COPY src/reserve_inventory reserve_inventory

RUN zip -r reserve-inventory.zip Gemfile* function.rb reserve_inventory.rb reserve_inventory vendor

CMD "/bin/bash"
