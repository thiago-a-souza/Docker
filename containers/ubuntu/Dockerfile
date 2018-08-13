FROM ubuntu:latest 
ENV PS1 "[\h]@\w> "
RUN useradd -m thiago && \
    echo "alias l=\"ls -lrt\"" >> /home/thiago/.bashrc 
USER thiago
WORKDIR /home/thiago
