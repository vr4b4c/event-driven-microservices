build-and-deploy:
	$(MAKE) app-dist-archive
	$(MAKE) infra-plan

infra-plan:
	$(MAKE) -C infra plan

infra-apply:
	$(MAKE) -C infra apply

infra-destroy:
	$(MAKE) -C infra destroy

app-deps-install:
	$(MAKE) -C src deps-install

app-console:
	$(MAKE) -C src console

app-test-suite:
	$(MAKE) -C src test-suite

app-dist-archive:
	 $(MAKE) app-dist-image
	 $(MAKE) app-extract-dist-archive
	 $(MAKE) app-upload-dist-archive

app-dist-image:
	docker buildx build --platform linux/x86_64 --target dist -t orders-service-dist:x86_64-latest .

app-extract-dist-archive:
	set -e; \
	CONTAINER_ID=$$(docker create --platform linux/x86_64 orders-service-dist:x86_64-latest) ;\
	docker cp $$CONTAINER_ID:/var/task/orders-service.zip - > dist/orders-service.zip; \
	docker rm -v $$CONTAINER_ID;

app-upload-dist-archive:
	aws s3 cp --profile=private-dev --region=eu-central-1 dist/orders-service.zip s3://ordering-platform-api
