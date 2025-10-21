FROM registry.cn-beijing.aliyuncs.com/zexi/ubuntu:moonlight-qt-build.251022.0

ADD . /moonlight-qt

WORKDIR /moonlight-qt

RUN apt install -y fonts-wqy-zenhei
#RUN qmake6 "CONFIG+=embedded" moonlight-qt.pro
RUN qmake6 moonlight-qt.pro
RUN make debug
