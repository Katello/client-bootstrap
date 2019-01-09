DOCKER=docker
TEST_TARGETS=centos\:5 centos\:6 centos\:7
TEST3_TARGETS=fedora\:29
USE_SELINUX=$(shell test -d /sys/fs/selinux && echo ":Z")

test: $(addprefix test-,$(TEST_TARGETS)) $(addprefix test3-,$(TEST3_TARGETS)) lint

test-%:
	$(DOCKER) run -it --volume $(CURDIR):/app$(USE_SELINUX) --workdir=/app $* python bootstrap.py --help
	$(DOCKER) run -it --volume $(CURDIR):/app$(USE_SELINUX) --workdir=/app $* python setup.py sdist

test3-%:
	$(DOCKER) run -it --volume $(CURDIR):/app$(USE_SELINUX) --workdir=/app $* python3 bootstrap.py --help
	$(DOCKER) run -it --volume $(CURDIR):/app$(USE_SELINUX) --workdir=/app $* python3 setup.py sdist

lint:
	python -m flake8 --ignore E501,W504 ./bootstrap.py ./setup.py
	python -m pylint --reports=n --disable=I --ignore-imports=y ./bootstrap.py ./setup.py
