#!/bin/bash

# Definir variáveis
APP_DIR="/home/lizics/DevOpsProject/DevOps-0986869-Lizie"  # Diretório onde sua aplicação está
APP_PROCESS="python3 main.py"  # Nome do processo da aplicação que está rodando (ajuste se necessário)

# Navegar para o diretório da aplicação
cd "$APP_DIR" || exit 1

# Parar o processo da aplicação (se estiver em execução)
APP_PID=$(pgrep -f "$APP_PROCESS")
if [ -n "$APP_PID" ]; then
    echo "Parando a aplicação (PID: $APP_PID)..."
    kill -9 "$APP_PID"
else
    echo "Nenhum processo em execução encontrado para $APP_PROCESS."
fi

# Adicionar as alterações ao Git
git add .
git commit -m "Teste da aplicação antes do deploy"
git push origin main

# Baixar as atualizações do repositório Git
echo "Baixando a aplicação atualizada do repositório Git..."
git pull origin main

# Limpar arquivos não versionados e diretórios vazios com git clean
echo "Removendo arquivos não versionados..."
git clean -fdX   # Limpa arquivos não versionados e ignorados, preservando os rastreados

# Iniciar a aplicação
echo "Iniciando a aplicação..."
nohup python3 "$APP_DIR/main.py" > "$APP_DIR/app.log" 2>&1 &

echo "Deploy concluído com sucesso."

