# Guia Completo de Instalação em Servidor Ubuntu

Este guia detalha todo o processo de instalação do Sistema de Agendamento de Exames Ocupacionais em um servidor Ubuntu limpo.

## 📋 Requisitos do Servidor

- Ubuntu 20.04 LTS ou superior
- Acesso root ou sudo
- Conexão com internet
- Mínimo 2GB RAM
- Mínimo 20GB de espaço em disco

---

## 🚀 Passo 1: Atualizar o Sistema

```bash
# Atualizar lista de pacotes
sudo apt update

# Atualizar pacotes instalados
sudo apt upgrade -y

# Instalar dependências básicas
sudo apt install -y curl wget git build-essential libssl-dev libreadline-dev zlib1g-dev \
  libsqlite3-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev \
  software-properties-common libffi-dev
```

---

## 🔧 Passo 2: Instalar Ruby 3.0.0

### Opção A: Usando rbenv (Recomendado)

```bash
# Instalar rbenv
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# Adicionar rbenv ao PATH
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
source ~/.bashrc

# Instalar Ruby 3.0.0
rbenv install 3.0.0
rbenv global 3.0.0

# Verificar instalação
ruby -v
# Deve mostrar: ruby 3.0.0...
```

### Opção B: Usando apt (mais rápido, mas versão pode variar)

```bash
# Adicionar repositório Brightbox
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt update

# Instalar Ruby
sudo apt install -y ruby3.0 ruby3.0-dev

# Verificar instalação
ruby -v
```

---

## 💎 Passo 3: Instalar Bundler

```bash
# Instalar bundler
gem install bundler

# Verificar instalação
bundle -v
```

---

## 🗄️ Passo 4: Instalar e Configurar PostgreSQL

```bash
# Instalar PostgreSQL
sudo apt install -y postgresql postgresql-contrib libpq-dev

# Iniciar serviço PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Criar usuário para o banco de dados
sudo -u postgres createuser -s $USER

# Criar senha para o usuário
sudo -u postgres psql -c "ALTER USER $USER WITH PASSWORD 'sua_senha_aqui';"

# Verificar instalação
psql --version
```

---

## 🔴 Passo 5: Instalar e Configurar Redis

```bash
# Instalar Redis
sudo apt install -y redis-server

# Configurar Redis para iniciar automaticamente
sudo systemctl start redis-server
sudo systemctl enable redis-server

# Testar Redis
redis-cli ping
# Deve retornar: PONG
```

---

## 📦 Passo 6: Instalar Node.js e Yarn

```bash
# Instalar Node.js 18.x LTS
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Instalar Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn

# Verificar instalações
node -v
yarn -v
```

---

## 📥 Passo 7: Clonar o Repositório

```bash
# Navegar para o diretório home
cd ~

# Clonar o repositório
git clone https://github.com/cmscheffer/agendamento-exames.git

# Entrar no diretório
cd agendamento-exames
```

---

## ⚙️ Passo 8: Instalar Dependências do Projeto

```bash
# Instalar gems Ruby
bundle install

# Instalar dependências JavaScript
yarn install
```

---

## 🔐 Passo 9: Configurar Variáveis de Ambiente

```bash
# Copiar arquivo de exemplo
cp .env.example .env

# Editar arquivo .env
nano .env
```

Configure as seguintes variáveis no arquivo `.env`:

```bash
# Banco de dados
DATABASE_URL=postgresql://seu_usuario:sua_senha@localhost:5432/agendamento_exames_production

# Redis
REDIS_URL=redis://localhost:6379/0

# Email (Mailgun) - Configure após criar conta no Mailgun
MAILGUN_API_KEY=sua_chave_mailgun
MAILGUN_DOMAIN=seu_dominio.mailgun.org

# Admin email
ADMIN_EMAIL=admin@suaempresa.com.br

# Rails
SECRET_KEY_BASE=gerar_abaixo
RAILS_ENV=production

# Configurações adicionais
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
```

### Gerar SECRET_KEY_BASE:

```bash
# Gerar chave secreta
bundle exec rails secret

# Copie a chave gerada e cole no .env na linha SECRET_KEY_BASE=
```

---

## 🗃️ Passo 10: Criar e Configurar Banco de Dados

```bash
# Criar banco de dados
RAILS_ENV=production bundle exec rails db:create

# Executar migrações
RAILS_ENV=production bundle exec rails db:migrate

# Criar usuário admin inicial
RAILS_ENV=production bundle exec rails runner "
  User.create!(
    email: 'admin@empresa.com.br',
    password: 'Admin@123',
    nome: 'Administrador',
    role: :admin
  )
  puts '✅ Usuário admin criado!'
  puts 'Email: admin@empresa.com.br'
  puts 'Senha: Admin@123'
"
```

---

## 📧 Passo 11: Configurar Mailgun (Serviço de Email)

1. **Criar conta gratuita no Mailgun**:
   - Acesse: https://signup.mailgun.com/new/signup
   - Complete o cadastro

2. **Obter credenciais**:
   - Após login, vá em: Sending → Domains
   - Copie o "API Key" e "Domain"
   - Cole no arquivo `.env`

3. **Configurar DNS** (se usar domínio próprio):
   - Adicione os registros DNS fornecidos pelo Mailgun
   - Aguarde propagação (pode levar até 48h)

---

## 🔧 Passo 12: Configurar Credenciais Rails

```bash
# Editar credenciais (abrirá editor)
EDITOR="nano" bundle exec rails credentials:edit --environment production
```

Adicione as seguintes configurações:

```yaml
mailgun:
  api_key: sua_chave_mailgun
  domain: seu_dominio.mailgun.org

admin_email: admin@suaempresa.com.br

secret_key_base: sua_chave_gerada_anteriormente
```

Salve e feche (Ctrl+O, Enter, Ctrl+X no nano)

---

## 🎨 Passo 13: Compilar Assets

```bash
# Compilar assets para produção
RAILS_ENV=production bundle exec rails assets:precompile
```

---

## 🚀 Passo 14: Configurar Nginx como Proxy Reverso

```bash
# Instalar Nginx
sudo apt install -y nginx

# Criar arquivo de configuração
sudo nano /etc/nginx/sites-available/agendamento-exames
```

Cole a seguinte configuração:

```nginx
upstream agendamento_exames {
  server 127.0.0.1:3000 fail_timeout=0;
}

server {
  listen 80;
  server_name seu_dominio.com.br;  # Ou IP do servidor

  root /home/seu_usuario/agendamento-exames/public;

  try_files $uri/index.html $uri @agendamento_exames;

  location @agendamento_exames {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;
    proxy_pass http://agendamento_exames;
  }

  error_page 500 502 503 504 /500.html;
  client_max_body_size 4G;
  keepalive_timeout 10;
}
```

```bash
# Ativar site
sudo ln -s /etc/nginx/sites-available/agendamento-exames /etc/nginx/sites-enabled/

# Remover site padrão
sudo rm /etc/nginx/sites-enabled/default

# Testar configuração
sudo nginx -t

# Reiniciar Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

---

## 🔄 Passo 15: Configurar Systemd para Inicialização Automática

### Serviço Rails (Puma)

```bash
# Criar arquivo de serviço
sudo nano /etc/systemd/system/agendamento-exames.service
```

Cole o seguinte conteúdo:

```ini
[Unit]
Description=Agendamento de Exames - Rails Application
After=network.target

[Service]
Type=simple
User=seu_usuario
WorkingDirectory=/home/seu_usuario/agendamento-exames
Environment="RAILS_ENV=production"
Environment="PORT=3000"
ExecStart=/home/seu_usuario/.rbenv/shims/bundle exec puma -C config/puma.rb
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### Serviço Sidekiq (Background Jobs)

```bash
# Criar arquivo de serviço
sudo nano /etc/systemd/system/agendamento-exames-sidekiq.service
```

Cole o seguinte conteúdo:

```ini
[Unit]
Description=Agendamento de Exames - Sidekiq Background Jobs
After=network.target

[Service]
Type=simple
User=seu_usuario
WorkingDirectory=/home/seu_usuario/agendamento-exames
Environment="RAILS_ENV=production"
ExecStart=/home/seu_usuario/.rbenv/shims/bundle exec sidekiq
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### Ativar e Iniciar Serviços

```bash
# Recarregar systemd
sudo systemctl daemon-reload

# Iniciar serviços
sudo systemctl start agendamento-exames
sudo systemctl start agendamento-exames-sidekiq

# Habilitar inicialização automática
sudo systemctl enable agendamento-exames
sudo systemctl enable agendamento-exames-sidekiq

# Verificar status
sudo systemctl status agendamento-exames
sudo systemctl status agendamento-exames-sidekiq
```

---

## 🔐 Passo 16: Configurar Firewall (UFW)

```bash
# Permitir SSH
sudo ufw allow 22/tcp

# Permitir HTTP
sudo ufw allow 80/tcp

# Permitir HTTPS (para futuro certificado SSL)
sudo ufw allow 443/tcp

# Ativar firewall
sudo ufw enable

# Verificar status
sudo ufw status
```

---

## 🔒 Passo 17: Configurar SSL com Let's Encrypt (Opcional mas Recomendado)

```bash
# Instalar Certbot
sudo apt install -y certbot python3-certbot-nginx

# Obter certificado SSL
sudo certbot --nginx -d seu_dominio.com.br

# Renovação automática já está configurada
# Testar renovação
sudo certbot renew --dry-run
```

---

## ✅ Passo 18: Verificar Instalação

```bash
# Verificar logs do Rails
sudo journalctl -u agendamento-exames -f

# Verificar logs do Sidekiq
sudo journalctl -u agendamento-exames-sidekiq -f

# Verificar logs do Nginx
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

### Testar no navegador:

- Acesse: `http://seu_servidor_ip` ou `http://seu_dominio.com.br`
- Faça login com: `admin@empresa.com.br` / `Admin@123`

---

## 🔧 Comandos Úteis para Manutenção

```bash
# Reiniciar aplicação
sudo systemctl restart agendamento-exames
sudo systemctl restart agendamento-exames-sidekiq

# Ver logs em tempo real
sudo journalctl -u agendamento-exames -f

# Atualizar código do GitHub
cd ~/agendamento-exames
git pull origin main
bundle install
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails assets:precompile
sudo systemctl restart agendamento-exames

# Acessar console Rails
RAILS_ENV=production bundle exec rails console

# Executar migrations
RAILS_ENV=production bundle exec rails db:migrate

# Ver status de todos os serviços
sudo systemctl status agendamento-exames
sudo systemctl status agendamento-exames-sidekiq
sudo systemctl status nginx
sudo systemctl status postgresql
sudo systemctl status redis-server
```

---

## 🐛 Solução de Problemas Comuns

### Problema: Erro de conexão com banco de dados

```bash
# Verificar se PostgreSQL está rodando
sudo systemctl status postgresql

# Testar conexão
psql -U seu_usuario -d agendamento_exames_production -h localhost
```

### Problema: Sidekiq não está processando jobs

```bash
# Verificar se Redis está rodando
sudo systemctl status redis-server

# Testar Redis
redis-cli ping
```

### Problema: Assets não carregam

```bash
# Recompilar assets
RAILS_ENV=production bundle exec rails assets:clobber
RAILS_ENV=production bundle exec rails assets:precompile
sudo systemctl restart agendamento-exames
```

### Problema: Erro 502 Bad Gateway

```bash
# Verificar se aplicação está rodando
sudo systemctl status agendamento-exames

# Ver logs
sudo journalctl -u agendamento-exames -n 50
```

---

## 📊 Monitoramento

### Verificar uso de recursos:

```bash
# CPU e memória
htop

# Espaço em disco
df -h

# Processos Ruby
ps aux | grep ruby

# Conexões ao banco
sudo -u postgres psql -c "SELECT count(*) FROM pg_stat_activity;"
```

---

## 🔄 Backup Regular

```bash
# Criar script de backup
nano ~/backup_agendamento.sh
```

Cole o seguinte conteúdo:

```bash
#!/bin/bash
BACKUP_DIR="/home/seu_usuario/backups"
DATE=$(date +%Y%m%d_%H%M%S)

# Criar diretório de backup
mkdir -p $BACKUP_DIR

# Backup do banco de dados
pg_dump -U seu_usuario agendamento_exames_production > "$BACKUP_DIR/db_$DATE.sql"

# Backup de arquivos uploads (se houver)
tar -czf "$BACKUP_DIR/uploads_$DATE.tar.gz" /home/seu_usuario/agendamento-exames/storage

# Manter apenas últimos 7 backups
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup concluído: $DATE"
```

```bash
# Tornar executável
chmod +x ~/backup_agendamento.sh

# Adicionar ao cron para backup diário às 2h da manhã
crontab -e

# Adicione a linha:
0 2 * * * /home/seu_usuario/backup_agendamento.sh >> /home/seu_usuario/backup.log 2>&1
```

---

## 📞 Suporte

Se encontrar problemas:

1. Verifique os logs: `sudo journalctl -u agendamento-exames -n 100`
2. Consulte a documentação do Rails: https://guides.rubyonrails.org/
3. Verifique o README do projeto

---

## 🎉 Conclusão

Seu sistema está instalado e rodando! 

**Acesso:**
- URL: http://seu_dominio.com.br
- Login Admin: admin@empresa.com.br
- Senha: Admin@123

**⚠️ IMPORTANTE:** Altere a senha do admin após primeiro acesso!

---

**Desenvolvido para:** Sistema de Agendamento de Exames Ocupacionais  
**Versão:** 1.0  
**Última atualização:** 2025