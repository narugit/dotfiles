#!/bin/bash
DOTFILES_LINUX_IMAGE="dotfiles_test_ubuntu_20.04"
TEST_USER="devman"
TEST_USER_PASS="devman"

docker build -t "${DOTFILES_LINUX_IMAGE}" --build-arg TEST_USER=${TEST_USER} --build-arg TEST_USER_PASS=${TEST_USER_PASS} .
docker run --rm -it "${DOTFILES_LINUX_IMAGE}":latest su ${TEST_USER}

