.PHONY: deps-install
deps-install:
	@cd src; bundle install

.PHONY: console
console:
	@src/bin/console

.PHONY: test
test:
	@cd src; bundle exec rspec

.PHONY: dist-archive
dist-archive:
	 $(MAKE) dist-image
	 $(MAKE) extract-dist-archive
	 $(MAKE) upload-dist-archive

.PHONY: docker-image
dist-image:
	@docker buildx build --platform linux/x86_64 --target dist -t orders-service-dist:x86_64-latest .

.PHONY: extract-dist-archive
extract-dist-archive:
	@set -e; \
	CONTAINER_ID=$$(docker create --platform linux/x86_64 orders-service-dist:x86_64-latest) ;\
	docker cp $$CONTAINER_ID:/var/task/orders-service.zip - > dist/orders-service.zip; \
	docker rm -v $$CONTAINER_ID;

.PHONY: upload-dist-archive
upload-dist-archive:
	set -e; \
	cd "../terraform/envs/$(env)"; \
	BUCKET=$$(terraform output -json | jq -r .ordering_platform_api_s3_bucket_id.value); \
	aws s3 cp ../../../orders-service/dist/orders-service.zip s3://$$BUCKET;
