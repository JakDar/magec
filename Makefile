name = magec

up:
	docker run -v $$(pwd):/host --name=$(name) -it ubuntu:16.04 /bin/bash

start:
	docker start $(name)
exec:
	docker	exec -it $(name) /bin/bash
