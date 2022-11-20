FROM cloudflare/cloudflared:2022.10.3 as cloudflared-binary

FROM ubuntu:20.04

COPY --from=cloudflared-binary /usr/local/bin/cloudflared /usr/local/bin/

COPY ./run.sh /run.sh

RUN apt update && apt install wget -y
RUN wget https://github.com/mikefarah/yq/releases/download/v4.30.4/yq_linux_amd64.tar.gz -O -\
        | tar xz && mv yq_linux_amd64 /usr/local/bin/yq
RUN chmod +x /run.sh
ENTRYPOINT [ "/run.sh" ]