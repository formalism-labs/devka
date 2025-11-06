
export CLASSICO=../classico
export DEVKA=..
export DEVKA_USER=$(DEVKA)/../devka-user

DOCKER_BUILD_ARGS += \
	--build-arg DOS=$(OS) \
	--build-context devka=$(realpath $(DEVKA))

ifneq ($(wildcard $(DEVKA_USER)/*),)
DOCKER_BUILD_ARGS += --build-context devka_user=$(realpath $(DEVKA_USER))
endif

MK.docker=1

include $(CLASSICO)/mk/main
