FROM python:slim 

COPY requirements.txt /tmp/

RUN pip3 --no-cache-dir install -r /tmp/requirements.txt && \
    rm -rf /tmp/*
