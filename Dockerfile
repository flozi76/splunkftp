FROM splunk/splunk:latest
USER root

RUN apt-get update
RUN apt-get install -y vsftpd

# RUN apt-get update \
#     && apt-get install -y --no-install-recommends vsftpd \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*


# ENV FTP_USER=ftpuser \
#     FTP_PASS=supersecret \
#     FTP_HOME=default \
#     FTP_UID=1000 \
#     ONLY_UPLOAD=NO \
#     ONLY_DOWNLOAD=NO \
#     PASV_ENABLE=NO \
#     PASV_ADDRESS=florian.zimmermann@post.ch \
#     PASV_MIN=21100 \
#     PASV_MIN=21100 \
#     UMASK=022 \
# 	SPLUNK_START_ARGS=--accept-license \
# 	SPLUNK_PASSWORD=Test_1234

# COPY entrypoint.sh /usr/sbin/

RUN mv /etc/vsftpd.conf /etc/vsftpd.conf_orig

COPY vsftpd.conf /etc/
COPY entrypoint.sh  /usr/sbin/

RUN groupadd ftp-users \
&& mkdir -p /home/ftp-docs \
&& chmod 750 /home/ftp-docs \
&& chown root:ftp-users /home/ftp-docs

RUN useradd -g ftp-users -d /home/ftp-docs ftpUser \
&& chpasswd ftpUser password1

# RUN chown root:ftp-users /home/ftp-docs/*
# RUN chmod 740 /home/ftp-docs/*


#RUN mkdir /ftpdata
RUN mkdir -p /var/ftp/pub \
&& mkdir -p /var/ftp/pub/upload \
&& chmod 0777 /var/ftp/pub \
&& chown -R ftpUser:ftp-users /var/ftp/pub/ \
&& chown -R ftpUser:ftp-users /var/ftp/pub/upload/ \
&& echo "vsftpd test file" | sudo tee /var/ftp/pub/test.txt

# RUN chown -R nobody:nogroup /var/ftp/pub
# RUN chown -R root:ftp-users /var/ftp/pub
#RUN etc/init.d/vsftpd restart; exit 0


#RUN service vsftpd start
#RUN service vsftpd status

# RUN echo "local_enable=YES" >> /etc/vsftpd.conf \
#   && echo "listen=YES" >> /etc/vsftpd.conf \
#   && echo "chroot_local_user=YES" >> /etc/vsftpd.conf \
#   && echo "listen_ipv6=YES" >> /etc/vsftpd.conf \
#   && echo "anon_mkdir_write_enable=YES" >> /etc/vsftpd.conf \
#   && echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf \
#   && echo "background=NO" >> /etc/vsftpd.conf \
#   && echo "dirmessage_enable=YES" >> /etc/vsftpd.conf \
#   && echo "max_clients=10" >> /etc/vsftpd.conf \
#   && echo "max_per_ip=5" >> /etc/vsftpd.conf \
#   && echo "write_enable=YES" >> /etc/vsftpd.conf \
#   && echo "passwd_chroot_enable=yes" >> /etc/vsftpd.conf \
#   && echo "listen_ipv6=NO" >> /etc/vsftpd.conf \
#   && echo "seccomp_sandbox=NO" >> /etc/vsftpd.conf \
#   && echo "anonymous_enable=YES" >> /etc/vsftpd.conf \
#   && echo "xferlog_enable=YES" >> /etc/vsftpd.conf \
#   && echo "xferlog_file=/var/log/vsftpd.log" >> /etc/vsftpd.conf \
#   && echo "xferlog_std_format=NO" >> /etc/vsftpd.conf \
#   && echo "log_ftp_protocol=YES" >> /etc/vsftpd.conf \
# #  && cp /etc/vsftpd.conf /etc/vsftpd.conf_or \
#   && chmod +x /usr/sbin/entrypoint.sh

# CMD /usr/sbin/entrypoint.sh