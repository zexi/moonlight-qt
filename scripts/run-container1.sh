#!/bin/bash

IMG=registry.cn-beijing.aliyuncs.com/zexi/moonlight-qt:20251022.0-amd64

#xhost +SI:localuser:$(id -un)

#xhost +SI:localuser:root
	#--user=$(id -u):$(id -g) \
xhost +

docker run -ti \
	--ipc=host \
	--gpus all \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v $XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR \
	-e DISPLAY=$DISPLAY \
	-e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
	-e XDG_SESSION_TYPE=x11 \
	-e XAUTHORITY=/root/.Xauthority \
	-e QT_DEBUG_PLUGINS=1 \
	-e QT_QPA_PLATFORM=xcb \
	-h $HOSTNAME -v $HOME/.Xauthority:/root/.Xauthority:ro $IMG /moonlight-qt/app/moonlight
