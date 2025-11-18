#!/bin/bash

# Script de Backup Automático
# Sistema de Agendamento de Exames Ocupacionais

# Configurações
BACKUP_DIR="/home/seu_usuario/backups"
APP_DIR="/home/seu_usuario/agendamento-exames"
DB_NAME="agendamento_exames_production"
DB_USER="seu_usuario"
DATE=$(date +%Y%m%d_%H%M%S)

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}Iniciando Backup - $DATE${NC}"
echo -e "${YELLOW}========================================${NC}"

# Criar diretório de backup se não existir
mkdir -p $BACKUP_DIR

# 1. Backup do Banco de Dados
echo -e "\n${YELLOW}[1/3] Fazendo backup do banco de dados...${NC}"
pg_dump -U $DB_USER $DB_NAME > "$BACKUP_DIR/db_$DATE.sql"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backup do banco de dados concluído${NC}"
    # Comprimir backup do banco
    gzip "$BACKUP_DIR/db_$DATE.sql"
    echo -e "${GREEN}✓ Backup comprimido${NC}"
else
    echo -e "${RED}✗ Erro ao fazer backup do banco de dados${NC}"
fi

# 2. Backup de arquivos de upload (se existir)
echo -e "\n${YELLOW}[2/3] Fazendo backup de arquivos...${NC}"
if [ -d "$APP_DIR/storage" ]; then
    tar -czf "$BACKUP_DIR/uploads_$DATE.tar.gz" -C $APP_DIR storage
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Backup de arquivos concluído${NC}"
    else
        echo -e "${RED}✗ Erro ao fazer backup de arquivos${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Diretório storage não encontrado, pulando...${NC}"
fi

# 3. Backup de configurações importantes
echo -e "\n${YELLOW}[3/3] Fazendo backup de configurações...${NC}"
tar -czf "$BACKUP_DIR/config_$DATE.tar.gz" -C $APP_DIR \
    .env \
    config/credentials \
    config/master.key 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backup de configurações concluído${NC}"
else
    echo -e "${YELLOW}⚠ Alguns arquivos de configuração não foram encontrados${NC}"
fi

# 4. Limpar backups antigos (manter últimos 7 dias)
echo -e "\n${YELLOW}Limpando backups antigos...${NC}"
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backups antigos removidos${NC}"
fi

# 5. Mostrar estatísticas
echo -e "\n${YELLOW}========================================${NC}"
echo -e "${YELLOW}Resumo do Backup${NC}"
echo -e "${YELLOW}========================================${NC}"
echo -e "Data: $DATE"
echo -e "Localização: $BACKUP_DIR"
echo -e "Espaço utilizado:"
du -sh $BACKUP_DIR
echo -e "\nÚltimos 5 backups:"
ls -lht $BACKUP_DIR | head -6

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Backup concluído com sucesso!${NC}"
echo -e "${GREEN}========================================${NC}"

# Log do backup
echo "$(date): Backup concluído - $BACKUP_DIR" >> /home/seu_usuario/backup.log