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
	@docker buildx build --platform linux/x86_64 --target dist -t reserve-inventory-dist:x86_64-latest .

.PHONY: extract-dist-archive
extract-dist-archive:
	@set -e; \
	CONTAINER_ID=$$(docker create --platform linux/x86_64 reserve-inventory-dist:x86_64-latest) ;\
	docker cp $$CONTAINER_ID:/var/task/reserve-inventory.zip - > dist/reserve-inventory.zip; \
	docker rm -v $$CONTAINER_ID;

.PHONY: upload-dist-archive
upload-dist-archive:
	set -e; \
	cd "../terraform/envs/$(env)"; \
	BUCKET=$$(terraform output -json | jq -r .ordering_platform_api_s3_bucket_id.value); \
	aws s3 cp ../../../reserve-inventory/dist/reserve-inventory.zip s3://$$BUCKET;
