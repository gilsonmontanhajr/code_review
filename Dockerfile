FROM ubuntu

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y openjdk-8-jre openssh-server python

RUN mkdir /root/.ssh && chmod 700 /root/.ssh
COPY keys/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 0644 /root/.ssh/authorized_keys

RUN mkdir /app

EXPOSE 8000
EXPOSE 22
