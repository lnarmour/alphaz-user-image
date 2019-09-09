FROM ubuntu:18.04

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa -y -y && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk libxext-dev libxrender-dev libxtst-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Install libgtk as a separate step so that we can share the layer above with
# the netbeans image
RUN apt-get update && apt-get install -y libgtk2.0-0 libcanberra-gtk-module wget sudo vim git

RUN mkdir -p /home/developer /home/developer/bin && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo && \
    echo 'PATH=$PATH:/home/developer/bin/eclipse' >> /home/developer/.bashrc

USER developer

RUN cd /home/developer/bin && \
    wget http://www.cs.colostate.edu/AlphaZ/bundles/linux64.tar.gz && \
    tar xzf linux64.tar.gz && \
    rm -rf linux64.tar.gz && \ 
    sed -i 's|^RECENT_WORKSPACES=.*|RECENT_WORKSPACES=|' /home/developer/bin/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs

ENV HOME /home/developer
WORKDIR /home/developer
CMD /home/developer/bin/eclipse/eclipse
