FROM mono:5.2

#MAINTAINER Cayde Dixon <me@cazzar.net>

ENV COMMIT bd860e6ec92e61dbfd5476aae3f20ff5c7203fd4
RUN curl https://bintray.com/user/downloadSubjectPublicKey?username=bintray | apt-key add - && \
echo "deb http://dl.bintray.com/cazzar/shoko-deps jesse main" | tee -a /etc/apt/sources.list.d/shoko-deps.list

RUN apt-get update && \
apt-get install -y --force-yes \
libmediainfo0 \
librhash0 \
sqlite.interop \
git \
wget

RUN mkdir -p /usr/src/app /opt/shoko
COPY dockerinit.sh /opt
RUN chmod +x /opt/dockerinit.sh
WORKDIR /usr/src/app

RUN git clone https://github.com/roninkenji/ShokoServer.git -n --recurse-submodules source && \
cd source && \
git checkout ${COMMIT} && \
wget https://github.com/NuGet/Home/releases/download/3.3/NuGet.exe && \
mono NuGet.exe restore && \
xbuild /property:Configuration=CLI /property:OutDir=/opt/shoko/ && \
rm -rf /usr/src/app/source /opt/shoko/System.Net.Http.dll
WORKDIR /opt/shoko

ENTRYPOINT /opt/dockerinit.sh

