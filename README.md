## Ideas
- [ ] Secure API gateway with API key/JWT/...
- [ ] Add CI/CD using GH Actions
- [x] Add system architecture diagram
- [ ] Consistently name Makefile targets
- [ ] Research scalable mono-repo terraform files organization
- [ ] Move tfstate to remote backend ([idea](https://github.com/infinum/infrastructure-template/blob/main/terraform/init/AWS/README.md))
- [ ] Add Git hooks for linting

## System architecture diagram
![System diagram](assets/system-diagram.svg)

## Project setup
Configures env var manager ([direnv](https://direnv.net/)) and git hooks manager([pre-commit](https://pre-commit.com/))
```bash
make setup
```
