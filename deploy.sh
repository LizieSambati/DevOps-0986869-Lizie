#!/bin/bash

# Definir variáveis
APP_DIR="/home/lizics/DevOpsProject/DevOps-0986869-Lizie"  # Diretório onde sua aplicação está
APP_PROCESS="python3 main.py"  # Nome do processo da aplicação que está rodando (ajuste se necessário)

# Navegar para o diretório da aplicação
cd "$APP_DIR" || exit 1

# Adicionar as alterações ao Git
git add .
git commit -m "Atualizando a aplicação antes do deploy"
git push origin main

# Parar o processo da aplicação (se estiver em execução)
APP_PID=$(pgrep -f "$APP_PROCESS")
if [ -n "$APP_PID" ]; then
    echo "Parando a aplicação (PID: $APP_PID)..."
    kill -9 "$APP_PID"
else
    echo "Nenhum processo em execução encontrado para $APP_PROCESS."
fi

# Baixar as atualizações do repositório Git
echo "Baixando a aplicação atualizada do repositório Git..."
git pull origin main

# Remover arquivos antigos, exceto o diretório .git
echo "Removendo arquivos antigos..."
find "$APP_DIR" -type f ! -path "$APP_DIR/.git/*" -exec rm -f {} \;
find "$APP_DIR" -type d ! -path "$APP_DIR/.git" ! -path "$APP_DIR/.git/*" -empty -exec rmdir {} \;

# Iniciar a aplicação
echo "Iniciando a aplicação..."
nohup python3 "$APP_DIR/main.py" > "$APP_DIR/app.log" 2>&1 &

echo "Deploy concluído com sucesso."

