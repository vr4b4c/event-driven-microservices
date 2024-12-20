.PHONY: configure-backend
configure-backend:
	@backend/configure

.PHONY: dev-init
dev-init:
	$(MAKE) -C envs/dev init
	$(MAKE) -C envs/dev/orders-service init
	$(MAKE) -C envs/dev/reserve-inventory init

.PHONY: dev-apply
dev-apply:
	$(MAKE) -C envs/dev apply
	$(MAKE) -C ../orders-service dist-archive env=dev
	$(MAKE) -C envs/dev/orders-service apply
	$(MAKE) -C ../reserve-inventory dist-archive env=dev
	$(MAKE) -C envs/dev/reserve-inventory apply

.PHONY: dev-destroy
dev-destroy:
	$(MAKE) -C envs/dev/reserve-inventory destroy
	$(MAKE) -C envs/dev/orders-service destroy
	$(MAKE) -C envs/dev destroy
