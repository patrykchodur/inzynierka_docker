FROM debian:10

RUN apt-get update -y
RUN apt-get install -y vim gcc g++ nano man-db make curl git sed cmake libgtk2.0-dev libgcrypt-dev bison flex qtbase5-dev qttools5-dev qtmultimedia5-dev libqt5svg5-dev bash
# needed for newer version of wireshark
RUN apt-get install -y libc-ares-dev libpcap-dev

COPY . /home/root/

WORKDIR /home/root
RUN if ! [ -d wireshark ]; then git clone https://gitlab.com/wireshark/wireshark.git wireshark; fi
# 
RUN git -C wireshark checkout tags/wireshark-3.4.2

RUN if ! [ -d projekt_gemroc ]; then git clone https://github.com/patrykchodur/inzynierka.git projekt_gemroc; fi
RUN mkdir $(pwd)/wireshark/plugins/epan/inz && \
		ln -s $(pwd)/projekt_gemroc $(pwd)/wireshark/plugins/epan/inz
RUN sed '15 a plugins/epan/inz/projekt_gemroc' wireshark/CMakeListsCustom.txt.example > \
				wireshark/CMakeListsCustom.txt
RUN mkdir wireshark/build && \
		cd wireshark/build && \
		cmake .. && \
		cmake --build .

ENTRYPOINT [ "bash" ]
