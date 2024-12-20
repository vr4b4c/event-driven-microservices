.PHONY: dev-setup
dev-setup:
	@bin/setup
	$(MAKE) -C orders-service deps-install
	$(MAKE) -C reserve-inventory deps-install

.PHONY: tf-configure-backend
tf-configure-backend:
	$(MAKE) -C terraform configure-backend

.PHONY: tf-dev-init
tf-dev-init:
	$(MAKE) -C terraform dev-init

.PHONY: tf-dev-apply
tf-dev-apply:
	$(MAKE) -C terraform dev-apply

.PHONY: tf-dev-destroy
tf-dev-destroy:
	$(MAKE) -C terraform dev-destroy

.PHONY: test
test:
	$(MAKE) -C orders-service test
	$(MAKE) -C reserve-inventory test
