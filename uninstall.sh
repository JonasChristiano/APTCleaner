#!/bin/bash
# Script de desinstalação do limpeza.sh

set -euo pipefail

SCRIPT_NAME="aptcleaner"
INSTALL_PATH="/usr/local/bin/$SCRIPT_NAME"
CRON_FILE="/etc/cron.d/$SCRIPT_NAME"

echo "[INFO] Removendo $SCRIPT_NAME..."

# Remove o binário
if [ -f "$INSTALL_PATH" ]; then
    sudo rm "$INSTALL_PATH"
    echo "[INFO] Script removido de $INSTALL_PATH"
fi

# Remove cron job
if [ -f "$CRON_FILE" ]; then
    sudo rm "$CRON_FILE"
    echo "[INFO] Cron job removido"
fi

echo "[INFO] Desinstalação concluída."
