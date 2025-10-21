#!/bin/bash

TAG=20251022.0-amd64

#docker buildx build --platform linux/amd64,linux/arm64 --push \
#	-t registry.cn-beijing.aliyuncs.com/zexi/ubuntu:moonlight-qt-build.251022.0 \
#	-f ./Dockerfile.build .

#docker buildx build --platform linux/arm64 --push \
#docker buildx build --platform linux/amd64,linux/arm64 --push \
docker buildx build --platform linux/amd64 --push \
	-t registry.cn-beijing.aliyuncs.com/zexi/moonlight-qt:$TAG \
	-f ./Dockerfile .
