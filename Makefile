build:
	docker build \
		--target base \
		--tag josuedjhcayola/alpine-ansible/ansible:latest \
		.

.PHONY: push
push: build
	docker push \
		josuedjhcayola/alpine-ansible/ansible:latest
