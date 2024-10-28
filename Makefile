init: docker-down docker-pull docker-build docker-up api-init
up: docker-up
down: docker-down
restart: down up

docker-up:
	docker compose up -d

docker-down:
	docker compose down --remove-orphans

docker-down-clear:
	docker compose down -v --remove-orphans

docker-pull:
	docker compose pull

docker-build:
	docker compose build --pull

api-init: api-composer-install

api-composer-install:
	docker compose run --rm api-php-cli composer install

push: push-gateway push-frontend push-api

push-gateway:
	docker push ${REGISTRY}/food-gateway:${IMAGE_TAG}

push-frontend:
	docker push ${REGISTRY}/food-frontend:${IMAGE_TAG}

push-api:
	docker push ${REGISTRY}/food-api:${IMAGE_TAG}
	docker push ${REGISTRY}/food-api-php-fpm:${IMAGE_TAG}

build: build-gateway build-frontend build-api

build-gateway:
	docker --log-level=debug build --pull --file=gateway/docker/production/nginx/Dockerfile --tag=${REGISTRY}/food-gateway:${IMAGE_TAG} gateway/docker  --platform=linux/amd64

build-frontend:
	docker --log-level=debug build --pull --file=frontend/docker/production/nginx/Dockerfile --tag=${REGISTRY}/food-frontend:${IMAGE_TAG} frontend --platform=linux/amd64

build-api:
	docker --log-level=debug build --pull --file=api/docker/production/php-fpm/Dockerfile --tag=${REGISTRY}/food-api-php-fpm:${IMAGE_TAG} api --platform=linux/amd64
	docker --log-level=debug build --pull --file=api/docker/production/php-cli/Dockerfile --tag=${REGISTRY}/food-api-php-cli:${IMAGE_TAG} api --platform=linux/amd64
	docker --log-level=debug build --pull --file=api/docker/production/nginx/Dockerfile --tag=${REGISTRY}/food-api:${IMAGE_TAG} api --platform=linux/amd64

try-build:
	REGISTRY=localhost IMAGE_TAG=0 make build

deploy:
	ssh ${HOST} -p ${PORT} 'rm -rf site_${BUILD_NUMBER}'
	ssh ${HOST} -p ${PORT} 'mkdir site_${BUILD_NUMBER}'
	scp -P ${PORT} docker-compose-production.yml ${HOST}:site_${BUILD_NUMBER}/docker-compose.yml
	ssh ${HOST} -p ${PORT} 'cd site_${BUILD_NUMBER} && echo "COMPOSE_PROJECT_NAME=food" >> .env'
	ssh ${HOST} -p ${PORT} 'cd site_${BUILD_NUMBER} && echo "REGISTRY=${REGISTRY}" >> .env'
	ssh ${HOST} -p ${PORT} 'cd site_${BUILD_NUMBER} && echo "IMAGE_TAG=${IMAGE_TAG}" >> .env'
	ssh ${HOST} -p ${PORT} 'cd site_${BUILD_NUMBER} && docker compose pull'
	ssh ${HOST} -p ${PORT} 'cd site_${BUILD_NUMBER} && docker compose up --build --remove-orphans -d'
	ssh ${HOST} -p ${PORT} 'rm -f site'
	ssh ${HOST} -p ${PORT} 'ln -sr site_${BUILD_NUMBER} site'