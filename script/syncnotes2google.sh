#!/bin/bash
DEBUG=false
SLEEP=true

while getopts "sd" opt; do
  case $opt in
     s)
       SLEEP=false
       echo "kein Sleep"
      ;;
     d)
       DEBUG=true
       echo "mit debug"
       ;;
    \?)
       echo "Invalid option: -$OPTARG" >&2
       exit 1
       ;;
     :)
       echo "Option -$OPTARG requires an argument." >&2
       exit 1
       ;;
  esac
done

if $SLEEP; then
  sleep 35
fi

export JAVA_HOME=/u/m500288/jre1.8.0_60
cd /u/m500288/syncnotes2google
NOTES_HOME=/opt/ibm/notes

NOTES_JAR=${NOTES_HOME}/jvm/lib/ext/Notes.jar
CLASS_PATH="./syncnotes2google-jar-with-dependencies.jar: \
    ${NOTES_JAR}"

CLASS_PATH=`echo ${CLASS_PATH} | sed 's/ //g'`

export PATH=${PATH}:${NOTES_HOME}
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${NOTES_HOME}
export DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${NOTES_HOME}
CMD="$JAVA_HOME/bin/java -d32 \
           -Djava.library.path=${NOTES_HOME} \
           -classpath ${CLASS_PATH} \
           -Dhttp.proxyHost=www-proxy -Dhttp.proxyPort=8080 -Dhttps.proxyHost=www-proxy -Dhttps.proxyPort=8080"
if $DEBUG; then
  CMD="$CMD -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
fi
CMD="$CMD  com.googlecode.syncnotes2google.SyncNotes2Google"
echo $CMD
$CMD


