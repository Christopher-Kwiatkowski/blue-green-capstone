## The Makefile includes instructions on environment setup and lint tests
# Create and activate a virtual environment
# Install dependencies in requirements.txt
# Dockerfile should pass hadolint
# app.py should pass pylint
# (Optional) Build a simple integration test

install:kub


build:
	eksctl create cluster \
    --name blue-green \
    --region us-west-2 \
    --nodegroup-name standard-workers \
    --node-type t2.micro \
    --nodes 3 \
    --nodes-min 1 \
    --nodes-max 4 \
    --managed

lint:
	# See local hadolint install instructions:   https://github.com/hadolint/hadolint
	# This is linter for Dockerfiles
	./hadolint -f blue/Dockerfile



all: install lint test