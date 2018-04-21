SERVICE_NAME=hello-world-printer
MY_DOCKER_NAME=$(SERVICE_NAME)


.PHONY : test all %.test

deps:
		pip install -r requirements.txt; \
		pip install -r test_requirements.txt

lint:
		flake8 hello_world test

test:
		PYTHONPATH=. py.test  --verbose -s

run:
		PYTHONPATH=. FLASK_APP=hello_world flask run

docker_build:
		docker build -t $(MY_DOCKER_NAME) .

docker_run: docker_build
		docker run \
			--name hello-world-printer-dev \
			-p 5000:5000 \
			-d $(MY_DOCKER_NAME)


USERNAME=chachul
TAG=$(USERNAME)/$(MY_DOCKER_NAME)

docker_push:
			@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
			docker tag $(MY_DOCKER_NAME) $(TAG): \
			docker push $(TAG); \
			docker logout;
