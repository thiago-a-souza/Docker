FROM ubuntu:latest 
ENV PS1 "[\h]@\w> "
RUN useradd -m thiago && \
    echo "alias l=\"ls -lrt\"" >> /home/thiago/.bashrc 
USER thiago
WORKDIR /home/thiago
ENTRYPOINT for i in 3 2 1 ; do echo "Stopping this container in $i second(s)"; sleep 1; done


