#!/bin/bash

touch ~/.cache/docker_nv_reset.flag
docker build -t jeportie/nvjej_base:latest .
