.PHONY: dev-setup
dev-setup:
	@bin/setup
	$(MAKE) -C orders-service deps-install
	$(MAKE) -C reserve-inventory deps-install

.PHONY: tf-init
tf-init:
	$(MAKE) -C terraform init

.PHONY: tf-dev-apply
tf-dev-apply:
	$(MAKE) -C terraform/envs/dev apply
	$(MAKE) -C orders-service dist-archive env=dev
	$(MAKE) -C terraform/envs/dev/orders-service apply
	$(MAKE) -C reserve-inventory dist-archive env=dev
	$(MAKE) -C terraform/envs/dev/reserve-inventory apply

.PHONY: tf-dev-destroy
tf-dev-destroy:
	$(MAKE) -C terraform/envs/dev/reserve-inventory destroy
	$(MAKE) -C terraform/envs/dev/orders-service destroy
	$(MAKE) -C terraform/envs/dev destroy

.PHONY: test
test:
	$(MAKE) -C orders-service test
	$(MAKE) -C reserve-inventory test
