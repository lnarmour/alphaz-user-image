#!/bin/bash

PIECE="$1"

REPOS="";
declare -A unique_repos;
repos=$(cat /working/${PIECE}-plugins.p2f | grep 'repository loc' | sed "s|^.*='\(.*\)'.*$|\1|");
for r in $repos; do unique_repos["$r"]=''; done;
for r in "${!unique_repos[@]}"; do REPOS+="$r,"; done;
REPOS=$(echo $REPOS | sed 's|\(.*\),$|\1|');

IUIDS="";
ids=$(cat /working/${PIECE}-plugins.p2f | grep 'iu id' | sed "s|^.*iu id='\(.*\)' name.*$|\1|");
for iuid in $ids; do IUIDS+="$iuid,"; done;
IUIDS=$(echo $IUIDS | sed 's|\(.*\),$|\1|');

/eclipse/eclipse \
-nosplash \
-application org.eclipse.equinox.p2.director \
-repository $REPOS \
-installIU $IUIDS
