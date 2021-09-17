from projector-idea-u:latest
MAINTAINER haokaizhao

user root
run apt-get update -y
run apt-get install wget -y
run wget https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.deb
run apt-get install java-common -y
run dpkg --install amazon-corretto-8-x64-linux-jdk.deb
run apt-get install maven -y
RUN git config --global user.name "wuhuZhao"
RUN git config --global user.email hkzhao123@gmail.com
RUN echo "ok"
