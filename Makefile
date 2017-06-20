build:
	docker build . -t mojdigitalstudio/circleci-build-container

push:
	#@docker login -u $(DOCKER_HUB_USER) -p $(DOCKER_HUB_PASS) -e $(DOCKER_HUB_EMAIL)
	docker push mojdigitalstudio/circleci-build-container
