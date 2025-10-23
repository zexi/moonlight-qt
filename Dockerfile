FROM registry.cn-beijing.aliyuncs.com/zexi/ubuntu:moonlight-qt-build.251023.0

ADD . /moonlight-qt

WORKDIR /moonlight-qt

#RUN qmake6 "CONFIG+=embedded" moonlight-qt.pro
#RUN qmake6 moonlight-qt.pro
#RUN qmake6 CONFIG+=disable-wayland CONFIG+=disable-libdrm CONFIG+=disable-cuda PREFIX=/usr moonlight-qt.pro
RUN qmake6 CONFIG+=disable-wayland PREFIX=/usr moonlight-qt.pro
RUN make debug
