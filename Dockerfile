FROM docker.elastic.co/beats/filebeat:8.6.1
COPY --chown=root:filebeat filebeat.yml /usr/share/filebeat/filebeat.yml