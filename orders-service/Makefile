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
	docker buildx build --platform linux/x86_64 --target dist -t orders-service-dist:x86_64-latest .

extract-dist-archive:
	set -e; \
	CONTAINER_ID=$$(docker create --platform linux/x86_64 orders-service-dist:x86_64-latest) ;\
	docker cp $$CONTAINER_ID:/var/task/orders-service.zip - > dist/orders-service.zip; \
	docker rm -v $$CONTAINER_ID;

upload-dist-archive:
	aws s3 cp --profile=private-dev --region=eu-central-1 dist/orders-service.zip s3://ordering-platform-api
