#!/bin/bash
set -e

TUNNEL_NAME="test"
CLOUDFLARED_HOSTNAME="admin.grafana.purapetino.com"
CLOUDFLARED_SERVICE="http://192.168.1.49"

if [ -z "$TUNNEL_NAME" ]; then
  echo "Error: TUNNEL_NAME が設定されていません"
  exit 1
fi


if [ ! -s "/tmp/tunnel.yml" ]; then

cat <<EOF | tee /tmp/tunnel.yml
  ingress:
    - hostname: $CLOUDFLARED_HOSTNAME
      service: $CLOUDFLARED_SERVICE
    - service: http_status:404
EOF

echo "success: create config"

fi

if [ ! -e "$HOME/.cloudflared/cert.pem" ]; then
  cloudflared tunnel login
  echo "a"
else
  echo "a"
fi

# トンネルを作り直す
cloudflared tunnel delete -f "$TUNNEL_NAME" || true
cloudflared tunnel create "$TUNNEL_NAME"

list_tunnel () {
  cloudflared tunnel list --name "$TUNNEL_NAME" --output yaml
}

get_tunnel_id () {
  list_tunnel | yq eval '.[0].id' -
}

tunnel_uuid=$(get_tunnel_id)

yq e ".ingress.[] | select(.hostname != null) | .hostname" "/tmp/tunnel.yml" \
  | xargs -n 1 cloudflared tunnel route dns --overwrite-dns "$tunnel_uuid"

# 起動
cloudflared tunnel --config "/tmp/tunnel.yml" --no-autoupdate run "$tunnel_uuid"
