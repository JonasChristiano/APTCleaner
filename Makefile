# Makefile para gerenciamento do script limpeza

SCRIPT_NAME = aptcleaner
INSTALL_PATH = /usr/local/bin/$(SCRIPT_NAME)
CRON_FILE = /etc/cron.d/$(SCRIPT_NAME)

.PHONY: all install uninstall reinstall test lint

all: install

install:
	@echo "[INFO] Instalando $(SCRIPT_NAME)..."
	sudo cp aptcleaner.sh $(INSTALL_PATH)
	sudo chmod +x $(INSTALL_PATH)
	echo "0 12 * * 5 root $(INSTALL_PATH) >> /var/log/aptcleaner.log 2>&1" | sudo tee $(CRON_FILE) > /dev/null
	sudo chmod 644 $(CRON_FILE)
	@echo "[INFO] Instalação concluída."

uninstall:
	@echo "[INFO] Desinstalando $(SCRIPT_NAME)..."
	@if [ -f $(INSTALL_PATH) ]; then sudo rm $(INSTALL_PATH); fi
	@if [ -f $(CRON_FILE) ]; then sudo rm $(CRON_FILE); fi
	@echo "[INFO] Desinstalação concluída."

reinstall: uninstall install

test:
	@echo "[INFO] Executando teste do script..."
	@bash -n aptcleaner.sh

lint:
	@echo "[INFO] Rodando ShellCheck..."
	@shellcheck aptcleaner.sh || true
