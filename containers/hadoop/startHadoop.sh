#!/bin/bash
service ssh start

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

while true; do 
      sleep 3600;
done

