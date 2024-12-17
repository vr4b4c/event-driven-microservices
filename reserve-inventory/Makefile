init:
	$(MAKE) -C infra init

apply:
	$(MAKE) dist-archive
	$(MAKE) infra-apply

infra-plan:
	$(MAKE) -C infra plan

infra-apply:
	$(MAKE) -C infra apply

infra-destroy:
	$(MAKE) -C infra destroy

deps-install:
	$(MAKE) -C src deps-install

console:
	$(MAKE) -C src console

test:
	$(MAKE) -C src test-suite

dist-archive:
	 $(MAKE) dist-image
	 $(MAKE) extract-dist-archive
	 $(MAKE) upload-dist-archive

dist-image:
	docker buildx build --platform linux/x86_64 --target dist -t reserve-inventory-dist:x86_64-latest .

extract-dist-archive:
	set -e; \
	CONTAINER_ID=$$(docker create --platform linux/x86_64 reserve-inventory-dist:x86_64-latest) ;\
	docker cp $$CONTAINER_ID:/var/task/reserve-inventory.zip - > dist/reserve-inventory.zip; \
	docker rm -v $$CONTAINER_ID;

upload-dist-archive:
	aws s3 cp --profile=private-dev --region=eu-central-1 dist/reserve-inventory.zip s3://ordering-platform-api
