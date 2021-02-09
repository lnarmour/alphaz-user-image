FROM ubuntu:18.04

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa -y -y && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk libxext-dev libxrender-dev libxtst-dev rsync && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Install libgtk as a separate step so that we can share the layer above with
# the netbeans image
RUN apt-get update && apt-get install -y libgtk-3-dev libcanberra-gtk-module wget sudo vim git maven dbus-x11

RUN cd / && \
    wget http://cs.colostate.edu/~lnarmour/rsrc/eclipse-2019.tar.gz && \
    tar xzf eclipse-2019.tar.gz && \
    rm -rf eclipse-2019.tar.gz 

RUN mkdir /working
ADD install-plugins.sh /working/install-plugins.sh
ADD required-plugins.p2f /working/required-plugins.p2f
ADD alphaz-plugins.p2f /working/alphaz-plugins.p2f
RUN bash /working/install-plugins.sh "required" && \
    bash /working/install-plugins.sh "alphaz"

# omit spurious and likely ignorable GTK library accessibility warnings
ENV NO_AT_BRIDGE 1 
ENV ALPHAZ_REPO_ROOT /root/git/alphaz

ADD start.sh /opt/start.sh
RUN chmod 755 /opt/start.sh

ENV HOME /root
WORKDIR /root
CMD /opt/start.sh
