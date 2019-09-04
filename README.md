# docker-androidbuild
This image can build aosp and codeaurora source (with kernel) based on ubuntu

# How to run
docker run -d \
  --hostname=jenkinsbuild \
  --dns=[DNS1] \
  --dns=[DNS2] \
  -e LOCAL_USER_ID=`id -u $USER` \
  -e LOCAL_USER_NAME=jenkinsci \
  -p 2201:22 \
  -v $HOME/user/jenkinsci:/home/jenkinsci/source \
  -v $HOME/.ccache:/home/jenkinsci/.ccache \
  -v $HOME/docker:/home/jenkinsci/docker \
  -v /home/mirror:/home/mirror \
  -t helios30/android-build

