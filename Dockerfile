FROM rosnertech1/glpi:10.0.17

# Instalar dependências adicionais se necessário
RUN apt-get update && apt-get install -y \
    curl \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Configurar permissões
RUN chown -R www-data:www-data /var/www/html/glpi

# Expor a porta 80
EXPOSE 80

CMD ["apache2-foreground"] 