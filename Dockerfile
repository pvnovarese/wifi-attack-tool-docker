FROM kalilinux/kali-rolling
LABEL org.opencontainers.image.authors="pvn@novarese.net"
ENV LANG en_US.UTF-8

RUN apt-get update && \
	echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
	apt-get dist-upgrade -y && \
 	apt-get install locales -y && \
	echo "${LANG}" | tr '.' ' ' > /etc/locale.gen && locale-gen && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata && \
	DEBIAN_FRONTEND=noninteractive apt-get install debconf-utils -y && \
 	echo "locales locales/default_environment_locale select ${LANG}" | debconf-set-selections && \
	echo "locales locales/locales_to_be_generated multiselect ${LANG} UTF-8" | debconf-set-selections && \
 	DEBIAN_FRONTEND=noninteractive apt-get install -y locales aircrack-ng hostapd dnsmasq git sudo python3-pip procps kmod && \
    git clone https://github.com/Danyalkhattak/wifi-attack-tool.git && \
    cd wifi-attack-tool/ && \
    pip3 install --no-cache-dir --break-system-packages -r requirements.txt && \
	apt-get purge debconf-utils -y
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /etc/dpkg/dpkg.cfg.d/force-unsafe-io var/lib/dpkg/status-old /var/lib/apt/lists/*

WORKDIR /wifi-attack-tool

CMD [ "/usr/bin/python3","main.py" ]
