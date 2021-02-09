#!/bin/bash

DIR="/root/eclipse-workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings";
mkdir -p $DIR;


FILE="$DIR/org.eclipse.core.runtime.prefs";
if [[ ! -f "$FILE" ]]; then
  echo "content-types/org.eclipse.xtend.core.Xtend.contenttype/charset=UTF-8" > $FILE
  echo "eclipse.preferences.version=1" >> $FILE;
fi

FILE="$DIR/fr.loria.eclipse.tom.prefs";
if [[ ! -f "$FILE" ]]; then
  echo "eclipse.preferences.version=1" > $FILE;
  echo "included_file_location=/root/git/alphaz/bundles/org.polymodel.algebra/src-gen/tom\:/root/git/alphaz/bundles/org.polymodel.polyhedralIR/src-gen/tom\:/root/git/alphaz/bundles/org.polymodel.scop/src-gen/tom\:/root/git/alphaz/bundles/org.polymodel.scop.dtiler/bin\:/root/git/alphaz/bundles/org.polymodel.scop.dtiler/src-tom\:" >> $FILE;
fi

/eclipse/eclipse
