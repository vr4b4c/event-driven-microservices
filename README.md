## Ideas
- [x] Add system architecture diagram
- [x] Consistently name Makefile targets
- [x] Research scalable mono-repo terraform files organization ([Anton Pura](https://www.youtube.com/watch?v=nMVXs8VnrF4), [Infinum DevOps](https://github.com/infinum/infrastructure-template/blob/main/terraform/README.md))
- [x] Move tfstate to remote backend ([Infinum DevOps](https://github.com/infinum/infrastructure-template/blob/main/terraform/init/AWS/README.md), [Anton Pura](https://www.youtube.com/watch?v=GgQE85Aq2z4))
- [x] Add Git hooks for linting
- [x] Document setup
- [x] Remove DynamoDB for backend locking (replaced by native S3 locking)
- [ ] Secure API gateway with API key/JWT/...
- [ ] Add CI/CD using GH Actions
- [ ] Extract common service logic into reusable package
- [ ] Enable tf remote backend state encryption (described in Anton Pura's video)

## System architecture diagram
![System diagram](assets/system-diagram.svg)

## Project setup
Configures env var manager ([direnv](https://direnv.net/)) and git hooks manager([pre-commit](https://pre-commit.com/))
```bash
make setup
```

## Terraform remote AWS S3 backend
To create Terraform backend resources (S3 bucket) use
```bash
make tf-configure-backend action=create resource=terraform-e-d-m-ecomm region=eu-central-1
```

To remove Terraform backend resources use
```bash
make tf-configure-backend action=destroy resource=terraform-e-d-m-ecomm region=eu-central-1
```

## Terraform AWS authentication
AWS provider authentication is done through environment variables. Check [AWS docs](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-envvars.html) for more details on available options.
