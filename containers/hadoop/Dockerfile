FROM debian:jessie

RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -t jessie-backports -y curl unzip openssh-server openjdk-8-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*        

# JAVA
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre"
ENV PATH $PATH:$JAVA_HOME/bin 

# passwordless login
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys && \
    echo "alias ls=\"ls --color=auto\"" >> ~/.bashrc && \
    echo "alias l=\"ls -lrt\"" >> ~/.bashrc 

COPY config /root/.ssh/
COPY startHadoop.sh /root

# HADOOP ENV VARIABLES
ENV HADOOP_VERSION 2.7.6
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR "$HADOOP_HOME/etc/hadoop"
ENV HADOOP_INSTALL $HADOOP_HOME
ENV HADOOP_MAPRED_HOME $HADOOP_HOME
ENV HADOOP_COMMON_HOME $HADOOP_HOME
ENV HADOOP_HDFS_HOME $HADOOP_HOME
ENV HADOOP_YARN_HOME $HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/lib/native
ENV HADOOP_OPTS "-Djava.library.path=$HADOOP_HOME/lib/native"
ENV PATH $PATH:$HADOOP_HOME/bin 

RUN cd /usr/local && \
    curl -OL http://www-us.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -zxf hadoop-${HADOOP_VERSION}.tar.gz && \
    rm -rf hadoop-${HADOOP_VERSION}.tar.gz && \
    chown -R root:root hadoop-${HADOOP_VERSION} && \
    ln -s /usr/local/hadoop-${HADOOP_VERSION} /usr/local/hadoop && \
    mkdir -p /data/hdfs/namenode && \
    mkdir -p /data/hdfs/datanode 

COPY core-site.xml $HADOOP_CONF_DIR
COPY yarn-site.xml $HADOOP_CONF_DIR
COPY hdfs-site.xml $HADOOP_CONF_DIR
COPY hadoop-env.sh $HADOOP_CONF_DIR
COPY mapred-site.xml $HADOOP_CONF_DIR  

RUN  service ssh start && \
     $HADOOP_HOME/bin/hdfs namenode -format && \
     $HADOOP_HOME/sbin/start-dfs.sh && \
     $HADOOP_HOME/sbin/start-yarn.sh  

# Hadoop - MapReduce Web UI
EXPOSE 8088

# Hadoop - Namenode Web UI
EXPOSE 50070

ENTRYPOINT ["/root/startHadoop.sh"]

