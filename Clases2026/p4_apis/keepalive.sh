#!/bin/bash
# Ping al server de Render cada 5 min para mantenerlo vivo
# Uso: ./keepalive.sh (Ctrl+C para frenar)

URL="https://apis-p4-ios.onrender.com/"

while true; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
  echo "$(date '+%H:%M:%S') — ping $URL → $STATUS"
  sleep 300
done
