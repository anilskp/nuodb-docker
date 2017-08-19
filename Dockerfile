FROM ubuntu:14.04
ENV nuodb_pkg nuodb_2.5.5.1_amd64.deb
RUN /usr/bin/apt-get update && /usr/bin/apt-get -y install \
   default-jre-headless \
      supervisor

# add the nuodb package to the image and run the install
ADD http://download.nuohub.org/$nuodb_pkg /tmp/
RUN /usr/bin/dpkg -i /tmp/$nuodb_pkg

# copy the supervisor conf file into the image
COPY supervisord.conf /etc/supervisor/conf.d/

# add a wrapper that will stage all properties and use it on entry
ADD run.sh /tmp/
RUN /bin/chmod +x /tmp/run.sh
CMD /tmp/run.sh
