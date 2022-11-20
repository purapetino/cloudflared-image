# cloudflared-image

cloudflaredをdockerやk8sで動かすためのimage

# 使い方

## 1コンテナに一つのホストを登録する場合

- `docker-compose.yaml`

```yaml
version: '3'

services:
  container:
    image: ghcr.io/purapetino/cloudflared-tunnel:1.0.0-2022.10.3
    stdin_open: true
    network_mode: host
    environment:
      - TUNNEL_NAME=hoge
      - CLOUDFLARED_HOSTNAME=hogehoge.purapetino.com
      - CLOUDFLARED_SERVICE=http://192.168.1.1:8080
```

## 1コンテナに複数ホストもしくは変数で管理したくない

docker-compose.yamlと同じ階層にtunnel.ymlを配置してください

- `docker-compose.yaml`

```yaml
version: '3'

services:
  container:
    image: ghcr.io/purapetino/cloudflared-tunnel:1.0.0-2022.10.3
    stdin_open: true
    network_mode: host
    environment:
      - TUNNEL_NAME=hoge
    volumes:
      - type: bind
        source: "./tunnel.yml"
        target: "/tmp/tunnel.yml"
```

- `tunnel.yml`

```yaml
ingress:
  - hostname: hogehoge.purapetino.com
    service: http://192.168.1.1:8080
  - service: http_status:404
```