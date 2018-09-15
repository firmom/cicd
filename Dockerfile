FROM goatcms/webslots
RUN apt-get update

# install docker dependencies
RUN apt-get -y install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

# install docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update
RUN apt-get -y install docker-ce

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

# nodejs packages and upgread
RUN \
  npm install -g n && \
  npm install -g gulp && \
  npm install -g jshint && \
  npm install -g bower && \
  npm install -g yarn

# ruby
RUN apt-get install -y ruby-full

# sass install
RUN gem install sass

# RAN static file server
RUN go get -u github.com/m3ng9i/ran

# Add config
COPY config/slots /app/config/slots
COPY config/tasks /app/config/tasks

# Add home template
COPY home /staticdata/home

# entrypoint
COPY custom-entrypoint.sh "/app/docker/custom-entrypoint.sh"
RUN chmod +x "/app/docker/custom-entrypoint.sh"
ENTRYPOINT ["/app/docker/custom-entrypoint.sh"]
CMD []
