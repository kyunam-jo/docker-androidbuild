FROM ubuntu:xenial
MAINTAINER Kyunam Jo <kyunam.jo@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

#apt-get update
RUN apt-get update && apt-get -y upgrade

# sudo command -y install
RUN apt-get -y install sudo apt-utils debconf-utils dialog
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
RUN apt-get update

# Set Timezone
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Prepare build tool
RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip python ccache imagemagick vim net-tools gosu bc libssl-dev locales kmod tzdata bash-completion rsync openssl

# Additional build tool
RUN apt-get -y install filepp
RUN apt-get -y install lib32z1 lib32ncurses5 lib32stdc++6 isc-dhcp-server nfs-kernel-server minicom resolvconf gawk wget diffstat texinfo chrpath socat libsdl1.2-dev make xsltproc docbook-utils fop dblatex xmlto realpath qemu-user
RUN apt-get -y install cpio

# install python external package
RUN apt-get -y install python-pip
RUN pip install --upgrade pip
RUN pip install html2text

#locale settings
RUN locale-gen --purge en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
#RUN echo -e 'LANG="en_US.UTF-8"' > /etc/default/locale

RUN apt-get -y install openssh-server ssh
RUN sed  -i -e "s/^#?UsePAM yes/UsePAM no/g"  -e 's/^.*Port 22$/Port 22/g' /etc/ssh/sshd_config

# Adding REPO
ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/bin/repo
RUN chmod +rx /usr/bin/repo

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV DEBIAN_FRONTEND newt

# Add default user - jenkinsci
RUN useradd --system -G sudo -u 1000 -d /home/builder -ms /bin/bash builder
#USER builder
#WORKDIR /home/builder

# Copy create build user
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh", "/bin/bash"]
