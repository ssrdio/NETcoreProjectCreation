.PHONY: debugimage releaseimage run

debugimage:
	@echo "building docker image..."
	docker build --build-arg build=Debug -t {PROJECT_NAME} .

releaseimage:
	@echo "building docker image..."
	docker build --no-cache --build-arg build=Release -t {PROJECT_NAME} .

run:
	@echo "running image..."
	docker run -p {PORT_NUMBER}:80 -e ASPNETCORE_ENVIRONMENT=Development --rm {PROJECT_NAME}