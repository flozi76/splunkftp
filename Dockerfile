FROM splunk/splunk:latest
USER root

ENV FTP_USER=ftpuser \
    FTP_PASS=supersecret \
    FTP_HOME=default \
    FTP_UID=1000 \
    ONLY_UPLOAD=NO \
    ONLY_DOWNLOAD=NO \
    PASV_ENABLE=NO \
    PASV_ADDRESS=florian.zimmermann@post.ch \
    PASV_MIN=21100 \
    PASV_MIN=21100 \
    UMASK=022 \
	SPLUNK_START_ARGS=--accept-license \
	SPLUNK_PASSWORD=Test_1234 \

COPY entrypoint.sh /usr/sbin/

RUN apt-get update \
    && apt-get install -y --no-install-recommends vsftpd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "local_enable=YES" >> /etc/vsftpd.conf \
  && echo "chroot_local_user=YES" >> /etc/vsftpd.conf \
  && echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf \
  && echo "background=NO" >> /etc/vsftpd.conf \
  && echo "dirmessage_enable=YES" >> /etc/vsftpd.conf \
  && echo "max_clients=10" >> /etc/vsftpd.conf \
  && echo "max_per_ip=5" >> /etc/vsftpd.conf \
  && echo "write_enable=YES" >> /etc/vsftpd.conf \
  && echo "passwd_chroot_enable=yes" >> /etc/vsftpd.conf \
  && echo "listen_ipv6=NO" >> /etc/vsftpd.conf \
  && echo "seccomp_sandbox=NO" >> /etc/vsftpd.conf \
  && sed -i "s/anonymous_enable=YES/anonymous_enable=NO/" /etc/vsftpd.conf \
  && cp /etc/vsftpd.conf /etc/vsftpd.conf_or \
  && chmod +x /usr/sbin/entrypoint.sh

CMD /usr/sbin/entrypoint.sh