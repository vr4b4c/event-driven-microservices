## Ideas
- [ ] Secure API gateway with API key/JWT/...
- [ ] Add CI/CD using GH Actions
- [x] Add system architecture diagram
- [x] Consistently name Makefile targets
- [x] Research scalable mono-repo terraform files organization ([Anton Pura](https://www.youtube.com/watch?v=nMVXs8VnrF4), [Infinum DevOps](https://github.com/infinum/infrastructure-template/blob/main/terraform/README.md))
- [ ] Move tfstate to remote backend ([idea](https://github.com/infinum/infrastructure-template/blob/main/terraform/init/AWS/README.md))
- [x] Add Git hooks for linting
- [x] Document setup
- [ ] Extract common service logic into reusable package

## System architecture diagram
![System diagram](assets/system-diagram.svg)

## Project setup
Configures env var manager ([direnv](https://direnv.net/)) and git hooks manager([pre-commit](https://pre-commit.com/))
```bash
make setup
```

## Terraform environment initialization
Initialize each infrastructure environment. Terraform environment initialization consists of creating AWS S3 bucket for hosting remote terraform state, and AWS DynamoDB table for concurrency control.
```bash
make tf-init action=create project=infinum-e-d-m-ecomm region=eu-central-1 environment=production
```

To remove infrastructure environment use following command
```bash
make tf-init action=destroy project=infinum-e-d-m-ecomm region=eu-central-1 environment=production
```

## Terraform AWS authentication
AWS provider authentication is done through environment variables. Check [AWS docs](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-envvars.html) for more details on available options.

## Infrastructure management
Show infra execution plan for platform and all services. Note it might not work for if dependant state is not up-to-date for interconnected services.
```bash
make plan
```

Apply infra plan for platform and all services.
```bash
make apply
```

Remove infra resources for platform and all services.
```bash
make destroy
```
