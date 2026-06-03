# Dockerfile — Portfólio DevOps
# Ambiente de desenvolvimento local com Nginx + live-server

#Usamos Node Alpine para instalar o live-server (hot reload)
FROM node:20-alpine

RUN npm install -g live-server@1.2.2

WORKDIR /app

EXPOSE 8080

#Comando padrão: inicia live-server apontando para /app/src
#--no-browser: não tenta abrir browser dentro do container
#--host=0.0.0.0: aceita conexões externas (necessário para port mapping)
#--port=8080: porta interna
CMD ["live-server", "src", "--port=8080", "--host=0.0.0.0", "--no-browser"]
