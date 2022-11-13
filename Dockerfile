FROM ubuntu:22.04

RUN mkdir -p /opt/hifi4
WORKDIR /opt/hifi4

RUN apt-get update && \
    apt-get install -y wget zstd

RUN wget https://cdn.iflyos.cn/public/lisa-binary/xt-venus/XtensaTools_RI_2020_4_linux.tar.zst && \
    tar -xvf XtensaTools_RI_2020_4_linux.tar.zst && \
    rm -f XtensaTools_RI_2020_4_linux.tar.zst && \
    wget https://cdn.iflyos.cn/public/lisa-binary/xt-venus/venus_hifi4_linux.tar.zst && \
    tar -xvf venus_hifi4_linux.tar.zst && \
    rm -f venus_hifi4_linux.tar.zst

ENV INSTALL_DIR=/opt/hifi4/RI-2020.4-linux
ENV TOOLS_DIR=${INSTALL_DIR}/XtensaTools
ENV CORE_DIR=${INSTALL_DIR}/venus_hifi4

ENV PARAMS_FILE=${CORE_DIR}/config/venus_hifi4-params

RUN sed -i "s|/././home/xpgcust/tree/RI-2020.4/ib/tools/swtools-x86_64-linux|${TOOLS_DIR}|g" ${PARAMS_FILE} && \
    sed -i "s|/././project/cust/genapp/RI-2020.4/build/chipskytek/prod/venus_hifi4/333958/RI-2020.4/venus_hifi4|${CORE_DIR}|g" ${PARAMS_FILE} && \
    sed -i "s|/././usr/xtensa/tools-8.0|${TOOLS_DIR}/Tools|g" ${PARAMS_FILE}

ENV PATH=${INSTALL_DIR}/XtensaTools/bin:${PATH}
ENV XTENSA_CORE=venus_hifi4
ENV XTENSA_SYSTEM=${INSTALL_DIR}/venus_hifi4/config
