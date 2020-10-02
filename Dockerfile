FROM ubuntu:18.04

# Install libgtk as a separate step so that we can share the layer above with
# the netbeans image
RUN apt-get update && apt-get install -y libgtk2.0-0 libcanberra-gtk-module wget sudo vim git subversion openssh-client

RUN mkdir -p /home/developer/bundles

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa -y -y && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk libxext-dev libxrender-dev libxtst-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN mkdir -p /home/developer/bin && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

USER developer

COPY resources/eclipse-java-2019-03-R-linux-gtk-x86_64.tar.gz  /home/developer/eclipse.tar.gz
RUN echo 'Installing eclipse' && \
    tar -xf /home/developer/eclipse.tar.gz -C /home/developer/bin

#RUN mkdir -p /home/developer/bin/eclipse/configuration/.settings && \
#    echo 'MAX_RECENT_WORKSPACES=10' > /home/developer/bin/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs && \ 
#    echo 'RECENT_WORKSPACES=/home/developer/workspace' >> /home/developer/bin/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs && \
#    echo 'RECENT_WORKSPACES_PROTOCOL=3' >> /home/developer/bin/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs && \
#    echo 'SHOW_RECENT_WORKSPACES=false' >> /home/developer/bin/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs && \
#    echo 'SHOW_WORKSPACE_SELECTION_DIALOG=true' >> /home/developer/bin/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs && \
#    echo 'eclipse.preferences.version=1' >> /home/developer/bin/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs

ENV HOME /home/developer
WORKDIR /home/developer
CMD /bin/bash
