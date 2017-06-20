build:
	docker build . -t mojdigitalstudio/circleci-build-container

push:
	@docker login -u $(DOCKER_HUB_USER) -p $(DOCKER_HUB_PASS)
	docker push mojdigitalstudio/circleci-build-container
