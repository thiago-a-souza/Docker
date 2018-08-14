FROM gettyimages/spark:2.1.0-hadoop-2.7

ARG ZEPPELIN_VERSION="0.8.0"
ARG ZEPPELIN_DIR="zeppelin-${ZEPPELIN_VERSION}-bin-netinst"
ARG ZEPPELIN_TGZ="${ZEPPELIN_DIR}.tgz"

RUN echo "ZEPPELIN_VERSION = $ZEPPELIN_VERSION"
RUN echo "ZEPPELIN_DIR = $ZEPPELIN_DIR"
RUN echo "ZEPPELIN_TGZ = $ZEPPELIN_TGZ"

ENV PS1 "[\h]@\w> "
ENV ZEPPELIN_PORT 8080
ENV ZEPPELIN_HOME /usr/${ZEPPELIN_DIR}
ENV ZEPPELIN_CONF_DIR $ZEPPELIN_HOME/conf
ENV ZEPPELIN_NOTEBOOK_DIR $ZEPPELIN_HOME/notebook

RUN mkdir -p $ZEPPELIN_HOME && \
    mkdir -p $ZEPPELIN_HOME/logs && \
    cd /usr && \    
    curl -SOL http://www-eu.apache.org/dist/zeppelin/zeppelin-${ZEPPELIN_VERSION}/${ZEPPELIN_TGZ} && \
    tar -zxf ${ZEPPELIN_TGZ} && \
    rm -rf ${ZEPPELIN_TGZ} && \ 
    echo "alias ls=\"ls --color=auto\"" >> ~/.bashrc && \
    echo "alias l=\"ls -lrt\"" >> ~/.bashrc

ENTRYPOINT $ZEPPELIN_HOME/bin/zeppelin.sh

EXPOSE 8080 4040

