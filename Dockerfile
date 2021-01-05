FROM debian:10

# user for ssh connection
ARG USERNAME=gemroc
ARG PASSWORD=gemroc1
# wireshark version must be listed in tags (wireshark git repository)
ARG WIRESHARK_VERSION=3.4.2

# INSTALLING NEEDED SOTWARE
RUN apt-get update -y
RUN apt-get install -y vim gcc g++ nano man-db make curl git sed cmake bash
# ssh server
RUN apt-get install -y openssh-server sudo
# wireshark dependencies
RUN apt-get install -y libgtk2.0-dev libgcrypt-dev bison flex qtbase5-dev qttools5-dev qtmultimedia5-dev libqt5svg5-dev libc-ares-dev libpcap-dev

COPY . /home/root/
WORKDIR /home/root

# DOWNLOADING AND SETTING WIRESHARK
RUN if ! [ -d wireshark ]; then git clone https://gitlab.com/wireshark/wireshark.git wireshark; fi
# change tag for different version of wireshark
RUN git -C wireshark checkout tags/wireshark${WIRESHARK_VERSION}

# DOWNLOADING AND SETTING PLUGIN
RUN if ! [ -d projekt_gemroc ]; then git clone https://github.com/patrykchodur/inzynierka.git projekt_gemroc; fi
RUN mkdir $(pwd)/wireshark/plugins/epan/inz
RUN ln -s $(pwd)/projekt_gemroc $(pwd)/wireshark/plugins/epan/inz

#BUILDING WIRESHARK AND PLUGIN
# plugin path added to CUSTOM_PLUGIN_SRC_DIR
RUN sed '15 a plugins/epan/inz/projekt_gemroc' wireshark/CMakeListsCustom.txt.example > \
				wireshark/CMakeListsCustom.txt
# build and install wireshark
RUN mkdir wireshark/build && \
		cd wireshark/build && \
		cmake .. && \
		cmake --build . && \
		cmake --build . --target install

# SETTING UP SSH SERVER
# add new user gemroc with UID 1000 and sudo privilages
RUN useradd -rm -d /home/${USERNAME} -s /bin/bash -g root -G sudo -u 1000 ${USERNAME}
# set password for user gemroc
RUN echo ${USERNAME}:${PASSWORD} | chpasswd
# configure X11
RUN echo 'X11Forwarding yes' >> /etc/ssh/sshd_config
RUN echo 'X11UseLocalhost yes' >> /etc/ssh/sshd_config
RUN echo 'AddressFamily inet' >> /etc/ssh/sshd_config
# start ssh
RUN service ssh start
# expose default port for ssh connections
EXPOSE 22

# TESTING
#RUN apt-get install -y firefox-esr


ENTRYPOINT [ "/usr/sbin/sshd", "-D" ]
#ENTRYPOINT [ "bash" ]
