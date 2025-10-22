#!/bin/bash

# 默认配置
TAG=20251022.0
BUILD_TAG="moonlight-qt-build.251022.0"
IMAGE_NAME="moonlight-qt"
BUILD_IMAGE_NAME="ubuntu"
DOCKERFILE="./Dockerfile"
BUILD_DOCKERFILE="./Dockerfile.build"

# 解析命令行参数
PLATFORMS=""
ARCH_SUFFIX=""
USE_BUILD_DOCKERFILE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --platform)
            PLATFORMS="$2"
            shift 2
            ;;
        --dockerfile)
            DOCKERFILE="$2"
            shift 2
            ;;
        --build-dockerfile)
            USE_BUILD_DOCKERFILE=true
            shift
            ;;
        --tag)
            TAG="$2"
            shift 2
            ;;
        --build-tag)
            BUILD_TAG="$2"
            shift 2
            ;;
        --image-name)
            IMAGE_NAME="$2"
            shift 2
            ;;
        --build-image-name)
            BUILD_IMAGE_NAME="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 [选项]"
            echo "选项:"
            echo "  --platform <平台>          指定要编译的平台 (linux/amd64, linux/arm64, linux/amd64,linux/arm64)"
            echo "  --dockerfile <文件>         指定Dockerfile路径 (默认: ./Dockerfile)"
            echo "  --build-dockerfile         使用Dockerfile.build进行编译"
            echo "  --tag <标签>               指定镜像标签 (默认: 20251022.0)"
            echo "  --build-tag <标签>         指定build镜像标签 (默认: moonlight-qt-build.251022.0)"
            echo "  --image-name <名称>        指定镜像名称 (默认: moonlight-qt)"
            echo "  --build-image-name <名称>  指定build镜像名称 (默认: ubuntu)"
            echo "  --help, -h                显示此帮助信息"
            echo ""
            echo "示例:"
            echo "  $0                                    # 编译当前系统架构"
            echo "  $0 --platform linux/amd64            # 编译AMD64架构"
            echo "  $0 --build-dockerfile                # 使用Dockerfile.build编译"
            echo "  $0 --build-dockerfile --build-tag my-build-tag  # 自定义build标签"
            echo "  $0 --platform linux/amd64,linux/arm64 # 编译多架构"
            exit 0
            ;;
        *)
            echo "未知参数: $1"
            echo "使用 --help 查看帮助信息"
            exit 1
            ;;
    esac
done

# 如果没有指定平台，使用当前系统架构
if [ -z "$PLATFORMS" ]; then
    CURRENT_ARCH=$(uname -m)
    case $CURRENT_ARCH in
        x86_64)
            PLATFORMS="linux/amd64"
            ARCH_SUFFIX="-amd64"
            ;;
        aarch64|arm64)
            PLATFORMS="linux/arm64"
            ARCH_SUFFIX="-arm64"
            ;;
        *)
            echo "警告: 无法识别当前系统架构 $CURRENT_ARCH，使用默认的 linux/amd64"
            PLATFORMS="linux/amd64"
            ARCH_SUFFIX="-amd64"
            ;;
    esac
else
    # 根据指定的平台设置架构后缀
    if [[ "$PLATFORMS" == *"linux/amd64"* && "$PLATFORMS" == *"linux/arm64"* ]]; then
        ARCH_SUFFIX="-multi"
    elif [[ "$PLATFORMS" == *"linux/amd64"* ]]; then
        ARCH_SUFFIX="-amd64"
    elif [[ "$PLATFORMS" == *"linux/arm64"* ]]; then
        ARCH_SUFFIX="-arm64"
    else
        ARCH_SUFFIX="-custom"
    fi
fi

# 根据是否使用build dockerfile来设置相关变量
if [ "$USE_BUILD_DOCKERFILE" = true ]; then
    # 使用Dockerfile.build
    FINAL_DOCKERFILE="$BUILD_DOCKERFILE"
    FINAL_TAG="$BUILD_TAG"
    FINAL_IMAGE_NAME="$BUILD_IMAGE_NAME"
else
    # 使用普通Dockerfile
    FINAL_DOCKERFILE="$DOCKERFILE"
    FINAL_TAG="${TAG}${ARCH_SUFFIX}"
    FINAL_IMAGE_NAME="$IMAGE_NAME"
fi

echo "编译平台: $PLATFORMS"
echo "使用Dockerfile: $FINAL_DOCKERFILE"
echo "镜像标签: registry.cn-beijing.aliyuncs.com/zexi/$FINAL_IMAGE_NAME:$FINAL_TAG"

echo '.qmake.cache
        .qmake.stash
        .vscode/
        app/Info.plist-e
        app/Makefile
        app/Makefile.Debug
        app/Makefile.Release
        app/Moonlight.app/
        app/qml_qmlcache.qrc
        certs/
        config.log
        h264bitstream/Makefile
        h264bitstream/Makefile.Debug
        h264bitstream/Makefile.Release
        h264bitstream/libh264bitstream.a
        moonlight-common-c/Makefile
        moonlight-common-c/Makefile.Debug
        moonlight-common-c/Makefile.Release
        moonlight-common-c/libmoonlight-common-c.a
        qmdnsengine/Makefile
        qmdnsengine/Makefile.Debug
        qmdnsengine/Makefile.Release
        qmdnsengine/libqmdnsengine.a
        soundio/Makefile
        soundio/Makefile.Debug
        soundio/Makefile.Release
        soundio/libsoundio.a
' | xargs -I{} rm -rf {}

# 执行docker buildx命令
docker buildx build --platform $PLATFORMS --push \
	-t registry.cn-beijing.aliyuncs.com/zexi/$FINAL_IMAGE_NAME:$FINAL_TAG \
	-f $FINAL_DOCKERFILE .
