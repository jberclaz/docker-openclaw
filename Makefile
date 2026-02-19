.PHONY: build up down logs sh clean

build:
	docker build --build-arg OPENCLAW_INSTALL_BROWSER=1 -t openclaw:latest .

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

sh:
	docker compose run --rm openclaw bash

clean:
	docker compose down -v
	docker rmi openclaw:latest
