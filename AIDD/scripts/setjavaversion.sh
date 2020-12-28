#!/bin/bash                                                                                                                                                                                                   

#env variables can be changed only if we call the script with source setJavaVersion.sh  

JDK8=/usr/lib/jvm/java-8-oracle/jre/  
JDK11=/usr/lib/jvm/java-11-openjdk-amd64/
                                                                                                                     
case $1 in
  8)
     export JAVA_HOME="$JDK8"
     export PATH=$JAVA_HOME/bin:$PATH     ;
  ;;
  11)
     export JAVA_HOME="$JDK11"
     export PATH=$JAVA_HOME/bin:$PATH     ;
  ;;
  *)
     error java version can only be 1.8 or 1.11
  ;;
esac
