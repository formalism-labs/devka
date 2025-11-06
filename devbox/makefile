
export CLASSICO=../classico
export DEVKA=..
export DEVKA_USER=$(DEVKA)/../devka-user

# DOS ?= ubuntu:noble
OSNICK ?= noble
IMAGE_NAME ?= devka/devbox:$(OSNICK).1

DOCKER_BUILD_ARGS += \
	--build-arg DOS=$(DOS) \
	--build-context devka=$(realpath $(DEVKA))

ifneq ($(wildcard $(DEVKA_USER)/*),)
DOCKER_BUILD_ARGS += --build-context devka_user=$(realpath $(DEVKA_USER))
endif

MK.docker=1

include $(CLASSICO)/mk/main
include $(CLASSICO)/mk/osnick.defs
