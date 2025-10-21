#!/bin/bash

IMG=registry.cn-beijing.aliyuncs.com/zexi/moonlight-qt:20251021.0

#xhost +SI:localuser:$(id -un)

#xhost +SI:localuser:root
#	#--user=$(id -u):$(id -g) \
#
#docker run -ti \
#	--ipc=host \
#	-v /tmp/.X11-unix:/tmp/.X11-unix \
#	-v $XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR \
#	-e DISPLAY=$DISPLAY \
#	-e QT_QPA_PLATFORM=X11 \
#	-e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
#	-h $HOSTNAME -v $HOME/.Xauthority:/root/.Xauthority $IMG bash #/moonlight-qt/app/moonlight

#docker run -e XDG_RUNTIME_DIR=/tmp \
#           -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
#           -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY  \
#           --user=$(id -u):$(id -g) \
#           imagename waylandapplicatio
#

x11docker $IMG /moonlight-qt/app/moonlight
