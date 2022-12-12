FROM ubuntu:22.04

# Set up toolchain

RUN mkdir -p /opt/hifi4
WORKDIR /opt/hifi4

RUN apt-get update && \
    apt-get install -y wget zstd

RUN wget https://cdn.iflyos.cn/public/lisa-binary/xt-venus/XtensaTools_RI_2021_7_linux.tar.zst && \
    tar -xvf XtensaTools_RI_2021_7_linux.tar.zst && \
    rm -f XtensaTools_RI_2021_7_linux.tar.zst && \
    wget https://cdn.iflyos.cn/public/lisa-binary/xt-venus/venus_hifi4_linux-2021.7.tar.zst && \
    tar -xvf venus_hifi4_linux-2021.7.tar.zst && \
    rm -f venus_hifi4_linux-2021.7.tar.zst

ENV INSTALL_DIR=/opt/hifi4/RI-2021.7-linux
ENV TOOLS_DIR=${INSTALL_DIR}/XtensaTools
ENV CORE_DIR=${INSTALL_DIR}/venus_hifi4

ENV PARAMS_FILE=${CORE_DIR}/config/venus_hifi4-params

RUN sed -i "s|/././home/xpgcust/tree/RI-2021.7/ib/tools/swtools-x86_64-linux|${TOOLS_DIR}|g" ${PARAMS_FILE} && \
    sed -i "s|/././project/cust/genapp/RI-2021.7/build/listenai_sw/swupgrade/venus_hifi4/351139/RI-2021.7/venus_hifi4|${CORE_DIR}|g" ${PARAMS_FILE} && \
    sed -i "s|/././usr/xtensa/tools-8.0|${TOOLS_DIR}/Tools|g" ${PARAMS_FILE}

ENV PATH=${INSTALL_DIR}/XtensaTools/bin:${PATH}
ENV XTENSA_CORE=venus_hifi4
ENV XTENSA_SYSTEM=${INSTALL_DIR}/venus_hifi4/config

# Set up user

WORKDIR /home
RUN groupadd -r hifi4 && \
    useradd -r -g hifi4 hifi4 -d /home && \
    apt-get update && apt-get install -y sudo && \
    chown -R hifi4:hifi4 /home && \
    echo "hifi4 ALL=(ALL:ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/hifi4

# Install additional tools

RUN apt-get update && \
    apt-get install -y make cmake ninja-build python3

USER hifi4
