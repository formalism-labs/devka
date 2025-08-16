
export CLASSICO=../classico
export DEVKA=..

# IMAGE_NAME ?= dvm:plucky

DOCKER_BUILD_ARGS += \
	--build-arg OS=$(OS) \
	--build-context devka=$(realpath $(DEVKA))

#	--build-context classico=$(CLASSICO) 

#ifeq ($(CACHE),0)
#DOCKER_BUILD_ARGS += --no-cache
#endif

#ifeq ($(DEBUG),1)
#export BUILDKIT_MAX_PARALLELISM=1
#DOCKER_BUILD_ARGS += --progress=plain
#endif

MK.docker=1

include $(CLASSICO)/mk/main

#build:
#	@docker buildx build -t $(IMAGE) $(DOCKER_BUILD_ARGS) .
