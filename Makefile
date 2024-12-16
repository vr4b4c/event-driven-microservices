apply:
	$(MAKE) -C infra apply
	$(MAKE) -C orders-service apply

destroy:
	$(MAKE) -C orders-service infra-destroy
	$(MAKE) -C infra destroy

platform-infra-plan:
	$(MAKE) -C infra plan

platform-infra-apply:
	$(MAKE) -C infra apply

orders-service-infra-plan:
	$(MAKE) -C orders-service infra-plan
