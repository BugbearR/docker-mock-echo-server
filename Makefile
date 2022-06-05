USER_NAME=bugbearr
IMAGE_NAME=mock-echo-server
REGISTRY=ghcr.io
REPO_NAME=${REGISTRY}/${USER_NAME}/${IMAGE_NAME}
PORT=8007

.PHONY: all
all: .build_done

.PHONY: run 
run: .build_done
	@docker run -d -p${PORT}:${PORT} ${REPO_NAME}

.PHONY: build
build: .build_done

.build_done: Dockerfile
	docker build . -t ${REPO_NAME}
	touch .build_done

.PHONY: test
test:
	-docker stop test-${IMAGE_NAME}
	-docker rm test-${IMAGE_NAME}
	docker run --name test-${IMAGE_NAME} -d -p${PORT}:${PORT} ${REPO_NAME}
	cat expected.txt | nc localhost ${PORT} >/tmp/result.txt
	docker stop test-${IMAGE_NAME}
	diff /tmp/result.txt expected.txt
	-docker rm test-${IMAGE_NAME}

.PHONY: test-edge
test-edge:
	-docker stop test-${IMAGE_NAME}
	-docker rm test-${IMAGE_NAME}
	docker run --name test-${IMAGE_NAME} -d -p${PORT}:${PORT} ${REPO_NAME}:edge
	cat expected.txt | nc localhost ${PORT} >/tmp/result.txt
	docker stop test-${IMAGE_NAME}
	diff /tmp/result.txt expected.txt
	-docker rm test-${IMAGE_NAME}

.PHONY: clean
clean:
	rm .build_done
