FROM arm32v7/ros:melodic

COPY qemu-arm-static /usr/bin
COPY entrypoint.sh /
RUN chmod +x entrypoint.sh
SHELL ["/bin/bash", "-c"]

ENTRYPOINT ["/entrypoint.sh"]
