#!/bin/bash
# Script de instalação do limpeza.sh
# Instala em /usr/local/bin e agenda cron job

set -euo pipefail

SCRIPT_NAME="aptcleaner"
INSTALL_PATH="/usr/local/bin/$SCRIPT_NAME"
CRON_FILE="/etc/cron.d/$SCRIPT_NAME"

echo "[INFO] Instalando $SCRIPT_NAME..."

# Copia o script principal
sudo cp aptcleaner.sh "$INSTALL_PATH"
sudo chmod +x "$INSTALL_PATH"

# Instala cron job (sexta às 12h, horário de Brasília)
echo "0 12 * * 5 root $INSTALL_PATH >> /var/log/aptcleaner.log 2>&1" | sudo tee "$CRON_FILE" > /dev/null
sudo chmod 644 "$CRON_FILE"

echo "[INFO] Instalação concluída. O script será executado toda sexta às 12h (BRT)."
