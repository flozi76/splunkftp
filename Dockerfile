FROM splunk/splunk:latest
USER root

RUN apt-get update
RUN apt-get install -y vsftpd

RUN mv /etc/vsftpd.conf /etc/vsftpd.conf_orig

COPY vsftpd.conf /etc/
# COPY ftp-entrypoint.sh  /usr/sbin/
COPY ftp-entrypoint.sh  /usr/local/bin/

RUN groupadd ftp-users \
&& mkdir -p /home/ftp-docs \
&& chmod 750 /home/ftp-docs \
&& chown root:ftp-users /home/ftp-docs \
&& useradd -g ftp-users -d /home/ftp-docs ftpUser \
&& chpasswd ftpUser password1

RUN mkdir -p /var/ftp/pub \
&& mkdir -p /var/ftp/pub/upload \
&& chmod 0777 /var/ftp/pub \
&& chmod 0777 /var/ftp/pub/upload \
&& chown -R ftpUser:ftp-users /var/ftp/pub/ \
&& chown -R ftpUser:ftp-users /var/ftp/pub/upload/ \
&& echo "vsftpd test file" | sudo tee /var/ftp/pub/test.txt

#RUN chmod +x /usr/sbin/ftp-entrypoint.sh
# RUN ln -s /usr/sbin/ftp-entrypoint.sh
# ENTRYPOINT ["ftp-entrypoint.sh"]

# CMD ["start"]