# syntax=docker/dockerfile:1.4

FROM ubuntu:22.04

RUN <<EOF
set -eux
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    zstd
rm -rf /var/lib/apt/lists/*

mkdir -p /opt/hifi4
cd /opt/hifi4

wget https://cdn.iflyos.cn/public/lisa-binary/xt-venus/XtensaTools_RI_2021_7_linux.tar.zst
tar -xvf XtensaTools_RI_2021_7_linux.tar.zst
rm -f XtensaTools_RI_2021_7_linux.tar.zst
wget https://cdn.iflyos.cn/public/lisa-binary/xt-venus/venus_hifi4_linux-2021.7.tar.zst
tar -xvf venus_hifi4_linux-2021.7.tar.zst
rm -f venus_hifi4_linux-2021.7.tar.zst

export INSTALL_DIR=/opt/hifi4/RI-2021.7-linux
export TOOLS_DIR=${INSTALL_DIR}/XtensaTools
export CORE_DIR=${INSTALL_DIR}/venus_hifi4

export PARAMS_FILE=${CORE_DIR}/config/venus_hifi4-params
sed -i "s|/././home/xpgcust/tree/RI-2021.7/ib/tools/swtools-x86_64-linux|${TOOLS_DIR}|g" ${PARAMS_FILE}
sed -i "s|/././project/cust/genapp/RI-2021.7/build/listenai_sw/swupgrade/venus_hifi4/351139/RI-2021.7/venus_hifi4|${CORE_DIR}|g" ${PARAMS_FILE}
sed -i "s|/././usr/xtensa/tools-8.0|${TOOLS_DIR}/Tools|g" ${PARAMS_FILE}
EOF

ENV PATH=/opt/hifi4/RI-2021.7-linux/XtensaTools/bin:${PATH}
ENV XTENSA_CORE=venus_hifi4
ENV XTENSA_SYSTEM=/opt/hifi4/RI-2021.7-linux/venus_hifi4/config

RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends \
    cmake \
    git \
    make \
    ninja-build \
    python3 \
    python3-pip
rm -rf /var/lib/apt/lists/*

pip3 install west
EOF
