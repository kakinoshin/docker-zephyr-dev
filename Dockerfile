FROM ubuntu:16.04

# proxy settings if necessary for apt-get
ENV http_proxy http://proxy.example.com:8080/
ENV https_proxy http://proxy.example.com:8080/

# build base envirnonment
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
	git make gcc g++ python3-ply ncurses-dev \
	python3-yaml dfu-util device-tree-compiler \
	wget xz-utils vim-nox usbutils sudo

# user settings
RUN useradd -d /opt/zephyr -m -s /bin/bash zephyr
RUN usermod -aG sudo zephyr
USER root
ADD /sudoers.txt /etc/sudoers
RUN chmod 440 /etc/sudoers
RUN mkdir -p /opt/zephyr

# for proxy environment
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q corkscrew
USER zephyr
RUN git config --global http.proxy http://proxy.example.com:8080
RUN git config --global https.proxy http://proxy.example.com:8080
RUN git config --global core.gitproxy "proxy-cmd.sh"
USER root
ADD /proxy-cmd.sh.txt /usr/local/bin/proxy-cmd.sh
RUN chmod +x /usr/local/bin/proxy-cmd.sh

# install Zephyr SDK
USER zephyr
RUN mkdir /opt/zephyr/sdk
WORKDIR /opt/zephyr/sdk
RUN wget https://github.com/zephyrproject-rtos/meta-zephyr-sdk/releases/download/0.9.1/zephyr-sdk-0.9.1-setup.run
RUN chmod +x zephyr-sdk-0.9.1-setup.run
USER root
RUN ./zephyr-sdk-0.9.1-setup.run
USER zephyr
ENV ZEPHYR_GCC_VARIANT zephyr
ENV ZEPHYR_SDK_INSTALL_DIR /opt/zephyr-sdk/

# for open-ocd
USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q libtool automake pkg-config libusb-1.0-0 libusb-1.0-0-dev
USER zephyr
WORKDIR /opt/zephyr
RUN git clone https://github.com/erwango/openocd-stm32.git
WORKDIR /opt/zephyr/openocd-stm32
RUN ./bootstrap
RUN ./configure --enable-maintainer-mode --enable-stlink
RUN make

# set initial path
WORKDIR /opt/zephyr
