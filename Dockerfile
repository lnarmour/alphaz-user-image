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
    if [ -f /home/developer/bin/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs ]; then sed -i 's|^RECENT_WORKSPACES=.*|RECENT_WORKSPACES=/home/developer/eclipse-workspace|' /home/developer/bin/eclipse/configuration/.settings/org.eclipse.ui.ide.prefs; fi; mkdir -p /home/developer/eclipse-workspace/; ln -s /home/developer/eclipse-workspace/ /home/developer/workspace;
COPY resources/eclipse.ini /home/developer/bin/eclipse/eclipse.ini

RUN eval sed -i "s~SVERSION~$(ls -l /home/developer/bin/eclipse/plugins | grep 'equinox.launcher_' | sed 's~.*_\(.*\).jar~\1~')~" /home/developer/bin/eclipse/eclipse.ini && \
    eval sed -i "s~LVERSION~$(ls -l /home/developer/bin/eclipse/plugins | grep 'equinox.launcher.gtk' | sed 's~.*x86_64_\(.*\)~\1~')~" /home/developer/bin/eclipse/eclipse.ini

ENV HOME /home/developer
WORKDIR /home/developer
CMD /home/developer/bin/eclipse/eclipse
