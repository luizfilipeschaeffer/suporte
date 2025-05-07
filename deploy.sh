#!/bin/bash

# Verificar se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "Erro: Docker não está rodando. Por favor, inicie o Docker primeiro."
    exit 1
fi

# Parar containers existentes mantendo os volumes
echo "Parando containers existentes..."
docker-compose down

# Verificar se os volumes existem
if ! docker volume ls | grep -q "glpi_db-data"; then
    echo "Criando volume para o banco de dados..."
    docker volume create glpi_db-data
fi

if ! docker volume ls | grep -q "glpi_glpi-data"; then
    echo "Criando volume para o GLPI..."
    docker volume create glpi_glpi-data
fi

if ! docker volume ls | grep -q "portainer_data"; then
    echo "Criando volume para o Portainer..."
    docker volume create portainer_data
fi

# Construir a imagem do GLPI
echo "Construindo imagem do GLPI..."
docker-compose build

# Iniciar os containers
echo "Iniciando containers..."
docker-compose up -d

# Aguardar o container do banco de dados iniciar
echo "Aguardando o container do banco de dados iniciar..."
sleep 10

# Verificar se o container do banco de dados está rodando
if ! docker ps | grep -q "glpi-db"; then
    echo "Erro: Container do banco de dados não está rodando!"
    exit 1
fi

# Obter o IP do container do banco de dados
DB_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' glpi-db)

# Exibir o IP várias vezes de forma destacada
echo -e "\n================================================"
echo "ENDEREÇO IP DO BANCO DE DADOS:"
echo "================================================"
for i in {1..10}; do
    echo "[$i] $DB_IP"
done
echo "================================================"

# Exibir informações dos volumes
echo -e "\nInformações dos volumes:"
docker volume ls | grep -E "glpi|portainer"

echo -e "\nDeploy concluído com sucesso!"
echo -e "\nAcesse o Portainer em: http://localhost:9000" 