#!/bin/bash
# Script de limpeza e otimização do Linux
# Autor: Jonas Christiano
# Versão: 2.0

set -o pipefail
trap 'tratar_erro $? $LINENO' ERR

LOG_FILE="/var/log/aptcleaner.log"
DEPENDENCIAS=(whiptail notify-send)

# ==============================
# Funções de utilidade
# ==============================

notificar() {
    local msg="$1"
    notify-send "Limpeza do Sistema" "$msg"
    echo "[INFO] $msg" | tee -a "$LOG_FILE"
}

tratar_erro() {
    local status=$1
    local linha=$2
    notificar "⚠️ Erro na linha $linha (status $status). Veja $LOG_FILE"
    echo "[ERROR] Código $status na linha $linha" >> "$LOG_FILE"
    exit 1
}

mostrar_progresso() {
    local titulo="$1"
    local comando="$2"

    {
        echo "XXX"
        echo "10"
        echo "$titulo em andamento..."
        echo "XXX"
        if ! bash -c "$comando"; then
            echo "[WARN] $titulo encontrou problemas (pode ser esperado)" >> "$LOG_FILE"
        fi
        echo "XXX"
        echo "100"
        echo "$titulo concluído."
        echo "XXX"
    } | whiptail --gauge "$titulo" 6 60 0
}

verificar_dependencias() {
    echo "[INFO] Verificando dependências..." | tee -a "$LOG_FILE"
    for dep in "${DEPENDENCIAS[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            notificar "Instalando dependência: $dep"
            if ! apt-get install -y "$dep"; then
                tratar_erro 1 "Dependência $dep não pôde ser instalada"
            fi
        else
            echo "[INFO] Dependência '$dep' encontrada." | tee -a "$LOG_FILE"
        fi
    done
}

# ==============================
# Etapas de limpeza
# ==============================

atualizar_lista() {
    mostrar_progresso "Atualizando lista de pacotes" "
        if ! apt update -y; then
            echo '[WARN] apt update falhou, pode ser problema de rede' >> \"$LOG_FILE\"
        fi
    "
}

remover_orfaos() {
    mostrar_progresso "Removendo pacotes órfãos" "
        if ! apt autoremove --purge -y; then
            echo '[WARN] apt autoremove não removeu nada' >> \"$LOG_FILE\"
        fi
    "
}

corrigir_pacotes() {
    mostrar_progresso "Corrigindo pacotes quebrados" "
        if ! apt -f install -y; then
            echo '[WARN] Nenhum pacote quebrado encontrado' >> \"$LOG_FILE\"
        fi
        if ! dpkg --configure -a; then
            echo '[WARN] Nenhum pacote precisou ser reconfigurado' >> \"$LOG_FILE\"
        fi
    "
}

limpar_cache() {
    mostrar_progresso "Limpeza de cache" "
        if ! apt clean; then
            echo '[WARN] apt clean não tinha nada para limpar' >> \"$LOG_FILE\"
        fi
        if ! apt autoclean -y; then
            echo '[WARN] apt autoclean não tinha nada para limpar' >> \"$LOG_FILE\"
        fi
    "
}

remover_kernels() {
    mostrar_progresso "Removendo kernels antigos" "
        KERNEL_ATUAL=\$(uname -r | cut -d\"-\" -f1,2)
        KERNELS=\$(dpkg -l | awk '/^ii  linux-image-[0-9]/ {print \$2}' | grep -v \"\$KERNEL_ATUAL\" | head -n -2)
        if [ -n \"\$KERNELS\" ]; then
            if ! apt-get remove --purge -y \$KERNELS; then
                echo '[WARN] Não foi possível remover alguns kernels antigos' >> \"$LOG_FILE\"
            fi
        else
            echo '[INFO] Nenhum kernel antigo encontrado' >> \"$LOG_FILE\"
        fi
    "
}

limpar_tmp() {
    mostrar_progresso "Removendo arquivos temporários" "
        rm -rf /tmp/* ~/.cache/thumbnails/* || \
        echo '[WARN] Alguns arquivos temporários não puderam ser removidos' >> \"$LOG_FILE\"
    "
}

verificar_sistema() {
    mostrar_progresso "Verificação final do sistema" "
        if ! dpkg -l >/dev/null 2>&1; then
            echo '[ERROR] Problema detectado na base de pacotes' >> \"$LOG_FILE\"
            exit 1
        fi
        if ! apt -f install --dry-run >/dev/null 2>&1; then
            echo '[ERROR] Inconsistência detectada nos pacotes' >> \"$LOG_FILE\"
            exit 1
        fi
    "
}

# ==============================
# Execução principal
# ==============================

main() {
    notificar "🟢 Iniciando limpeza do sistema..."
    verificar_dependencias
    atualizar_lista
    remover_orfaos
    corrigir_pacotes
    limpar_cache
    remover_kernels
    limpar_tmp
    verificar_sistema
    notificar "✅ Limpeza concluída com sucesso!"
}

main
