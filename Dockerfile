ARG HERMES_IMAGE=nousresearch/hermes-agent:latest
FROM ${HERMES_IMAGE}

USER root
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      dbus-x11 xfce4 xfce4-terminal tigervnc-standalone-server tigervnc-tools \
      novnc websockify supervisor procps curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/supervisor/conf.d /opt/hermes-box

COPY container/supervisord.conf /etc/supervisor/conf.d/hermes-box.conf
COPY container/start-desktop.sh container/healthcheck.sh /opt/hermes-box/
COPY container/hermes-terminal.desktop /usr/share/applications/hermes-terminal.desktop
RUN chmod 0755 /opt/hermes-box/*.sh

EXPOSE 5901 6080 9119
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 CMD ["/opt/hermes-box/healthcheck.sh"]
ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/opt/hermes/docker/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
