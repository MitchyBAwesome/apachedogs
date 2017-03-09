FROM httpd
EXPOSE 80
RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y curl && \
  apt-get install -y python2.7 && \
  cd /tmp && \
  curl -O https://bootstrap.pypa.io/get-pip.py && \
  python2.7 get-pip.py && \
  pip install awscli && \
  rm -rf /tmp/* && \
  rm -rf /var/lib/apt/lists/*
COPY ./httpd.conf /usr/local/apache2/conf/
COPY ./index.html /usr/local/apache2/htdocs/
COPY ./init.sh /tmp/init.sh
RUN chmod +x /tmp/init.sh
CMD /tmp/init.sh && httpd -D FOREGROUND
