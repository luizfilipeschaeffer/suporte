#!/bin/bash
set -e

# Aguardar o banco de dados estar pronto
echo "Aguardando o banco de dados estar pronto..."
while ! mysqladmin ping -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
    sleep 1
done

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