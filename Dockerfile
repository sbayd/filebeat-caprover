FROM docker.elastic.co/beats/filebeat:8.6.1
ARG KIBANA_HOST=${KIBANA_HOST}
ENV KIBANA_HOST=${KIBANA_HOST}
ARG ELASTIC_HOST=${ELASTIC_HOST}
ENV ELASTIC_HOST=${ELASTIC_HOST}
COPY --chown=root:filebeat filebeat.yml /usr/share/filebeat/filebeat.yml