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

test_cov:
		PYTHONPATH=. py.test  --verbose -s --cov=.

test_xunit:
		PYTHONPATH=. py.test  -s --cov=. --junit-xml=test_results.xml

run:
		PYTHONPATH=. FLASK_APP=hello_world flask run

test_smoke:
		curl --fail 127.0.0.1:5000

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
			docker tag $(MY_DOCKER_NAME) $(TAG); \
			docker push $(TAG); \
			docker logout;
