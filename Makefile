REGISTRY 	:= kenshin579
APP    		:= echo-server
TAG         := v0.2
IMAGE       := $(REGISTRY)/$(APP):$(TAG)


.PHONY: docker-build
docker-build:
	@docker build -t $(IMAGE) -f Dockerfile .

.PHONY: docker-push
docker-push: docker-build
	@docker push $(IMAGE)

.PHONY: docker-run
docker-run:
	@docker run -it kenshin579/$(APP)

.PHONY: clean
	go clean
	rm -rf bin

.PHONY: package
package:
	go mod tidy

.PHONY: build
build: package
	go build -v -o bin/$(APP) cmd/server/main.go

.PHONY: test
test:
	go test ./... -coverprofile=coverage.out
	go tool cover -html=coverage.out

.PHONY: swagger
swagger:
	@go get -d github.com/swaggo/swag/cmd/swag@v1.8.7
	@go install github.com/swaggo/swag/cmd/swag@v1.8.7
	@swag i --parseDepth=3 --parseDependency -g cmd/server/main.go
	@go mod tidy


.PHONY: curl-ping
curl-ping:
	@curl --location 'http://localhost:8080/ping'

