FROM rosnertech1/glpi:10.0.17

# Instalar dependências adicionais se necessário
RUN apt-get update && apt-get install -y \
    curl \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Configurar permissões
RUN chown -R www-data:www-data /var/www/html/glpi

# Configurar Apache para escutar em todas as interfaces
RUN sed -i 's/Listen 80/Listen 0.0.0.0:80/' /etc/apache2/ports.conf

# Expor a porta 80
EXPOSE 80

# Iniciar Apache em primeiro plano
CMD ["apache2-foreground"] 