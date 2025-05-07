#!/bin/bash
set -e

# Aguardar o banco de dados estar pronto
echo "Aguardando o banco de dados estar pronto..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    if mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; then
        echo "Banco de dados está pronto!"
        break
    fi
    
    echo "Tentativa $attempt de $max_attempts - Banco de dados ainda não está pronto..."
    attempt=$((attempt + 1))
    sleep 2
done

if [ $attempt -gt $max_attempts ]; then
    echo "Erro: Não foi possível conectar ao banco de dados após $max_attempts tentativas"
    exit 1
fi

# Configurar o arquivo de configuração do GLPI
cat > /var/www/html/glpi/config/config_db.php << EOF
<?php
class DB extends DBmysql {
   public \$dbhost = '$DB_HOST';
   public \$dbuser = '$DB_USER';
   public \$dbpassword = '$DB_PASSWORD';
   public \$dbdefault = '$DB_NAME';
}
EOF

# Ajustar permissões
chown -R www-data:www-data /var/www/html/glpi

# Executar o comando passado como argumento
exec "$@" 