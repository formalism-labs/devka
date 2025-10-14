
export CLASSICO=../classico
export DEVKA=..

DOCKER_BUILD_ARGS += \
	--build-arg DOS=$(OS) \
	--build-context devka=$(realpath $(DEVKA))

MK.docker=1

include $(CLASSICO)/mk/main
