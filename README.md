# APTCleaner
Limpeza e otimização automática para Debian e derivados. Remove pacotes órfãos, limpa cache, remove kernels antigos e arquivos temporários, com barra de progresso e notificações.

## 🚀 Funcionalidades
- Remove pacotes órfãos e quebrados
- Limpa cache do APT
- Remove kernels antigos (mantém os 2 mais recentes)
- Remove arquivos temporários
- Barra de progresso com `whiptail`
- Notificações gráficas com `notify-send`
- Log detalhado em `/var/log/aptcleaner.log`
- Checagem de dependências apenas na primeira execução ou em caso de erro

## 📦 Instalação
**Clone o repositório:**
```bash
git clone https://github.com/JonasChristiano/APTCleaner.git
cd APTCleaner
```

**Instale o script no sistema:**
```bash
sudo cp aptcleaner.sh /usr/local/bin/cleaner
sudo chmod +x /usr/local/bin/aptcleaner
```

## 🖥️ Uso
**Rodar manualmente:**
```bash
sudo aptcleaner
```

## ⏰ Execução automática
**Agendar para rodar toda sexta-feira às 12h (horário de Brasília):**
```bash
sudo crontab -e
```

**Adicionar a linha:**
```bash
0 12 * * 5 TZ=America/Sao_Paulo /usr/local/bin/aptcleaner
```

## 📝 Logs
**Os logs ficam disponíveis em:**
```bash
/var/log/aptcleaner.log
```

## 📜 Licença
Distribuído sob a licença MIT. Veja [LICENSE](LICENSE) para mais detalhes.