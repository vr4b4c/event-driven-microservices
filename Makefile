setup:
	pre-commit install --install-hooks

init:
	$(MAKE) -C infra init
	$(MAKE) -C orders-service init
	$(MAKE) -C reserve-inventory init

apply:
	$(MAKE) -C infra apply
	$(MAKE) -C orders-service apply
	$(MAKE) -C reserve-inventory apply

destroy:
	$(MAKE) -C reserve-inventory infra-destroy
	$(MAKE) -C orders-service infra-destroy
	$(MAKE) -C infra destroy

test:
	$(MAKE) -C orders-service test
	$(MAKE) -C reserve-inventory test

platform-infra-plan:
	$(MAKE) -C infra plan

platform-infra-apply:
	$(MAKE) -C infra apply

orders-service-infra-plan:
	$(MAKE) -C orders-service infra-plan

orders-service-infra-apply:
	$(MAKE) -C orders-service infra-apply

orders-service-apply:
	$(MAKE) -C orders-service apply
