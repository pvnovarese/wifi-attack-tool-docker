FROM kalilinux/kali-rolling
LABEL org.opencontainers.image.authors="pvn@novarese.net"
ENV LANG en_US.UTF-8

RUN apt-get update && \
	echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
	apt-get dist-upgrade -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata && \
	DEBIAN_FRONTEND=noninteractive apt-get install aircrack-ng hostapd dnsmasq git sudo python3-pip procps -y && \
    git clone https://github.com/Danyalkhattak/wifi-attack-tool.git && \
    cd wifi-attack-tool/ && \
    pip3 install --no-cache-dir --break-system-packages -r requirements.txt && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /etc/dpkg/dpkg.cfg.d/force-unsafe-io var/lib/dpkg/status-old /var/lib/apt/lists/*

WORKDIR /wifi-attack-tool

CMD [ "/usr/bin/python3","main.py" ]
