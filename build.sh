#!/usr/bin/env bash
set -e
UBUNTU_VERSIONS="18.04 16.04"
PYTHON_VERSIONS="3.7.1 3.7.2"
USER_ID=10000

for UBUNTU_VERSION in ${UBUNTU_VERSIONS}; do
	for PYTHON_VERSION in ${PYTHON_VERSIONS}; do
		echo "------------------------------"
		echo " ${UBUNTU_VERSION} ${PYTHON_VERSION}"
		echo "------------------------------"
		docker build \
			--no-cache \
			--build-arg UBUNTU_VERSION=${UBUNTU_VERSION} \
			--build-arg PYTHON_VERSION=${PYTHON_VERSION} \
			--build-arg UID=${USER_ID} \
			-t ubuntu_pyenv:${UBUNTU_VERSION}_${PYTHON_VERSION} \
			.
	done
done
