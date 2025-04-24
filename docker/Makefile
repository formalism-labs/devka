IMAGE=devka
CONTAINER=devka

DEVKA_USER_REPO=formalism-labs/devka-user

DOCKER_RUN_ARGS=--name $(CONTAINER) -it --rm -e DOCKER_NAME=$(CONTAINER)

ifeq ($(DAEMON),1)
DOCKER_RUN_ARGS += -d
endif

ifeq ($(CACHE),0)
DOCKER_BUILD_ARGS += --no-cache
endif

ifeq ($(DEBUG),1)
export BUILDKIT_MAX_PARALLELISM=1
DOCKER_BUILD_ARGS += --progress=plain
endif

ifeq ($(LOCAL),1)
DOCKER_BUILD_ARGS += \
	--build-context devka=$(HOME)/.devka \
	--build-context devka-user=$(HOME)/.devka-user \
	-f Dockerfile.local
else
DOCKER_BUILD_ARGS += \
	--build-arg DEVKA_USER_REPO=$(DEVKA_USER_REPO)
endif

build:
	@docker buildx build -t $(IMAGE) $(DOCKER_BUILD_ARGS) .

run:
	@docker run $(DOCKER_RUN_ARGS) $(IMAGE)

stop:
	@docker stop $(CONTAINER)

sh:
	@docker exec -it $(CONTAINER) bash -l

.PHONY: build run stop sh
