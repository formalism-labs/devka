define HELPTEXT
make build              Build the Docker image
  CACHE=0                 Disable build cache
  DEBUG=1                 Debug mode (not parallel, plain output)
  LOCAL=1                 Use local .devka and .devka-user directories instead of cloning
  DEVKA_USER_REPO=repo    Use custom devka-user repo (default: formalism-labs/devka-user)

make run     Run the Docker container
  DAEMON=1     Run the container in daemon mode

make stop    Stop the container
make sh      Open a shell in the running container
make help    Show this message
endef

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
	-f $(PWD)/Dockerfile.local
else
DOCKER_BUILD_ARGS += \
	--build-arg DEVKA_USER_REPO=$(DEVKA_USER_REPO) \
	-f $(PWD)/Dockerfile
endif

build:
	@docker buildx build -t $(IMAGE) $(DOCKER_BUILD_ARGS) ..

run:
	@docker run $(DOCKER_RUN_ARGS) $(IMAGE)

stop:
	@docker stop $(CONTAINER)

sh:
	@docker exec -it $(CONTAINER) bash -l

.PHONY: build run stop sh

MK.nobindir=1

CLASSICO=../classico
include $(CLASSICO)/mk/main
