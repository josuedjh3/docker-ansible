build:
	docker build \
		--target base \
		--tag josuedjhcayola/alpine-ansible1:latest \
		.

	docker build \
		--target develop \
		--tag josuedjhcayola/alpine-ansible1:develop \
		.

.PHONY: push
push: build
	docker push \
		josuedjhcayola/alpine-ansible1:latest

	docker push \
		josuedjhcayola/alpine-ansible1:develop

.PHONY: ansible
ansible:
	docker-compose run --rm --service-ports --use-aliases ansible --shell