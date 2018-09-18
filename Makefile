TEST_TARGETS=centos\:5 centos\:6 centos\:7
USE_SELINUX=$(shell test -d /sys/fs/selinux && echo ":Z")

test: $(addprefix test-,$(TEST_TARGETS)) lint

test-%:
	docker run -it --volume $(CURDIR):/app$(USE_SELINUX) --workdir=/app $* python bootstrap.py --help
	docker run -it --volume $(CURDIR):/app$(USE_SELINUX) --workdir=/app $* python setup.py sdist

lint:
	python -m flake8 --ignore E501 ./bootstrap.py ./setup.py
	python -m pylint --reports=n --disable=I --ignore-imports=y ./bootstrap.py ./setup.py
