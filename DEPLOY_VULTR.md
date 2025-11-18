# 🚀 Guia Completo de Deploy na Vultr

## Sistema de Agendamento de Exames Ocupacionais
### Deploy profissional em servidor VPS Vultr

---

## 📋 Parte 1: Criar Servidor na Vultr

### Passo 1.1: Acessar Vultr

1. Acesse: https://www.vultr.com/
2. Faça login ou crie uma conta
3. Clique em **"Deploy"** → **"Deploy New Server"**

### Passo 1.2: Escolher Configurações do Servidor

**Choose Server:**
- Selecione: **Cloud Compute - Shared CPU**

**Server Location:**
- Escolha a localização mais próxima dos seus usuários
- Recomendado para Brasil: **Miami** ou **São Paulo** (se disponível)

**Server Image:**
- Selecione: **Ubuntu 22.04 LTS x64**

**Server Size:**
- **Mínimo recomendado**: 
  - 2 GB RAM / 1 CPU / 55 GB SSD ($12/mês)
- **Ideal para produção**: 
  - 4 GB RAM / 2 CPU / 80 GB SSD ($24/mês)

**Additional Features:**
- ✅ Marque: **Enable IPv6**
- ✅ Marque: **Enable Auto Backups** (opcional, mas recomendado)

**Server Hostname & Label:**
- Hostname: `agendamento-exames`
- Label: `Agendamento de Exames Ocupacionais`

### Passo 1.3: Deploy

1. Clique em **"Deploy Now"**
2. Aguarde 2-5 minutos até o servidor estar pronto
3. Anote as credenciais:
   - **IP Address**: (ex: 45.76.123.45)
   - **Username**: root
   - **Password**: (será exibido na tela)

---

## 🔐 Parte 2: Conectar ao Servidor

### Passo 2.1: Acessar via SSH

**No Windows (usar PowerShell ou PuTTY):**
```powershell
ssh root@SEU_IP_AQUI
```

**No Mac/Linux:**
```bash
ssh root@SEU_IP_AQUI
```

**Digite a senha** fornecida pela Vultr quando solicitado.

### Passo 2.2: Atualizar Senha (Recomendado)

```bash
# Alterar senha do root
passwd

# Digite a nova senha duas vezes
```

---

## 👤 Parte 3: Criar Usuário para Deploy

```bash
# Criar novo usuário
adduser deploy

# Defina uma senha forte
# Preencha os dados (pode apertar Enter para pular)

# Adicionar ao grupo sudo
usermod -aG sudo deploy

# Mudar para o usuário deploy
su - deploy
```

**⚠️ IMPORTANTE**: Todos os comandos a seguir devem ser executados como usuário `deploy`

---

## 🔧 Parte 4: Atualizar Sistema e Instalar Dependências

```bash
# Atualizar sistema
sudo apt update
sudo apt upgrade -y

# Instalar dependências essenciais
sudo apt install -y curl wget git build-essential libssl-dev libreadline-dev \
  zlib1g-dev libsqlite3-dev libyaml-dev libxml2-dev libxslt1-dev \
  libcurl4-openssl-dev software-properties-common libffi-dev \
  autoconf bison libgdbm-dev libncurses5-dev automake libtool pkg-config
```

---

## 💎 Parte 5: Instalar Ruby com rbenv

```bash
# Instalar rbenv
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# Adicionar ao PATH
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
source ~/.bashrc

# Verificar instalação do rbenv
rbenv -v

# Instalar Ruby 3.0.0 (pode levar 10-15 minutos)
rbenv install 3.0.0

# Definir como versão global
rbenv global 3.0.0

# Verificar
ruby -v
# Deve mostrar: ruby 3.0.0

# Instalar Bundler
gem install bundler
rbenv rehash
```

---

## 🗄️ Parte 6: Instalar PostgreSQL

```bash
# Instalar PostgreSQL
sudo apt install -y postgresql postgresql-contrib libpq-dev

# Iniciar PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Criar usuário no PostgreSQL
sudo -u postgres createuser -s deploy

# Definir senha
sudo -u postgres psql -c "ALTER USER deploy WITH PASSWORD 'SenhaSegura123';"

# Verificar
psql --version
```

---

## 🔴 Parte 7: Instalar Redis

```bash
# Instalar Redis
sudo apt install -y redis-server

# Iniciar Redis
sudo systemctl start redis-server
sudo systemctl enable redis-server

# Testar
redis-cli ping
# Deve retornar: PONG
```

---

## 📦 Parte 8: Instalar Node.js e Yarn

```bash
# Instalar Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Instalar Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn

# Verificar
node -v
yarn -v
```

---

## 📥 Parte 9: Clonar Projeto do GitHub

```bash
# Navegar para home
cd ~

# Clonar repositório
git clone https://github.com/cmscheffer/agendamento-exames.git

# Entrar no diretório
cd agendamento-exames

# Verificar
ls -la
```

---

## ⚙️ Parte 10: Configurar Aplicação

### Passo 10.1: Instalar Dependências

```bash
# Instalar gems Ruby
bundle install

# Instalar dependências JavaScript
yarn install
```

### Passo 10.2: Configurar Variáveis de Ambiente

```bash
# Copiar arquivo de exemplo
cp .env.example .env

# Editar .env
nano .env
```

**Configure o arquivo `.env`:**

```bash
# Banco de dados
DATABASE_URL=postgresql://deploy:SenhaSegura123@localhost:5432/agendamento_exames_production

# Redis
REDIS_URL=redis://localhost:6379/0

# Email Mailgun (configurar depois)
MAILGUN_API_KEY=seu_mailgun_api_key
MAILGUN_DOMAIN=seu_dominio.mailgun.org

# Admin
ADMIN_EMAIL=admin@suaempresa.com.br

# Rails
SECRET_KEY_BASE=GERAR_ABAIXO
RAILS_ENV=production
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
```

**Salvar**: `Ctrl+O`, `Enter`, `Ctrl+X`

### Passo 10.3: Gerar SECRET_KEY_BASE

```bash
# Gerar chave secreta
bundle exec rails secret

# Copie a saída e edite o .env novamente
nano .env

# Cole a chave na linha SECRET_KEY_BASE=
# Salvar e sair
```

### Passo 10.4: Criar Banco de Dados

```bash
# Criar banco
RAILS_ENV=production bundle exec rails db:create

# Executar migrações
RAILS_ENV=production bundle exec rails db:migrate

# Criar usuário admin
RAILS_ENV=production bundle exec rails runner "
  User.create!(
    email: 'admin@empresa.com.br',
    password: 'Admin@123',
    nome: 'Administrador',
    role: :admin
  )
  puts '✅ Usuário admin criado!'
"
```

### Passo 10.5: Compilar Assets

```bash
# Compilar assets
RAILS_ENV=production bundle exec rails assets:precompile
```

---

## 📧 Parte 11: Configurar Mailgun (Email)

### Passo 11.1: Criar Conta Mailgun

1. Acesse: https://signup.mailgun.com/new/signup
2. Complete o cadastro (é grátis até 5.000 emails/mês)
3. Verifique seu email

### Passo 11.2: Obter Credenciais

1. Faça login no Mailgun
2. Vá em: **Sending** → **Domain Settings**
3. Copie:
   - **API Key**: (em Settings → API Keys)
   - **Domain**: (ex: sandboxXXX.mailgun.org)

### Passo 11.3: Configurar no Projeto

```bash
# Editar .env
nano .env

# Atualize as linhas:
# MAILGUN_API_KEY=sua_chave_api_aqui
# MAILGUN_DOMAIN=seu_dominio_mailgun

# Salvar e sair
```

---

## 🌐 Parte 12: Instalar e Configurar Nginx

```bash
# Instalar Nginx
sudo apt install -y nginx

# Criar arquivo de configuração
sudo nano /etc/nginx/sites-available/agendamento-exames
```

**Cole a seguinte configuração:**

```nginx
upstream agendamento_exames {
  server 127.0.0.1:3000 fail_timeout=0;
}

server {
  listen 80;
  server_name SEU_IP_OU_DOMINIO;

  root /home/deploy/agendamento-exames/public;

  try_files $uri/index.html $uri @agendamento_exames;

  location @agendamento_exames {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_redirect off;
    proxy_pass http://agendamento_exames;
  }

  error_page 500 502 503 504 /500.html;
  client_max_body_size 4G;
  keepalive_timeout 10;
}
```

**Salvar**: `Ctrl+O`, `Enter`, `Ctrl+X`

```bash
# Ativar site
sudo ln -s /etc/nginx/sites-available/agendamento-exames /etc/nginx/sites-enabled/

# Remover site padrão
sudo rm -f /etc/nginx/sites-enabled/default

# Testar configuração
sudo nginx -t

# Reiniciar Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

---

## 🔄 Parte 13: Configurar Systemd (Auto-Inicialização)

### Passo 13.1: Serviço Puma (Rails)

```bash
# Criar arquivo de serviço
sudo nano /etc/systemd/system/agendamento-exames.service
```

**Cole o seguinte:**

```ini
[Unit]
Description=Agendamento de Exames - Rails Application
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/home/deploy/agendamento-exames
Environment="RAILS_ENV=production"
Environment="PORT=3000"
ExecStart=/home/deploy/.rbenv/shims/bundle exec puma -C config/puma.rb
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Salvar e sair**

### Passo 13.2: Serviço Sidekiq (Background Jobs)

```bash
# Criar arquivo de serviço
sudo nano /etc/systemd/system/agendamento-exames-sidekiq.service
```

**Cole o seguinte:**

```ini
[Unit]
Description=Agendamento de Exames - Sidekiq
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/home/deploy/agendamento-exames
Environment="RAILS_ENV=production"
ExecStart=/home/deploy/.rbenv/shims/bundle exec sidekiq
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Salvar e sair**

### Passo 13.3: Atualizar Puma Config

```bash
# Editar configuração do Puma
nano ~/agendamento-exames/config/puma.rb
```

**Substitua `seu_usuario` por `deploy` em todas as linhas**

**Salvar e sair**

### Passo 13.4: Iniciar Serviços

```bash
# Recarregar systemd
sudo systemctl daemon-reload

# Iniciar serviços
sudo systemctl start agendamento-exames
sudo systemctl start agendamento-exames-sidekiq

# Habilitar auto-inicialização
sudo systemctl enable agendamento-exames
sudo systemctl enable agendamento-exames-sidekiq

# Verificar status
sudo systemctl status agendamento-exames
sudo systemctl status agendamento-exames-sidekiq
```

---

## 🔐 Parte 14: Configurar Firewall

```bash
# Permitir SSH
sudo ufw allow 22/tcp

# Permitir HTTP
sudo ufw allow 80/tcp

# Permitir HTTPS
sudo ufw allow 443/tcp

# Ativar firewall
sudo ufw enable

# Verificar
sudo ufw status
```

---

## 🔒 Parte 15: Configurar SSL (HTTPS) com Let's Encrypt

```bash
# Instalar Certbot
sudo apt install -y certbot python3-certbot-nginx

# Obter certificado SSL
# IMPORTANTE: Substitua seu_dominio.com.br pelo seu domínio real
sudo certbot --nginx -d seu_dominio.com.br

# Siga as instruções:
# 1. Digite seu email
# 2. Aceite os termos (Y)
# 3. Escolha se quer receber emails (Y/N)
# 4. Escolha opção 2 (Redirect HTTP to HTTPS)

# Testar renovação automática
sudo certbot renew --dry-run
```

---

## ✅ Parte 16: Testar Aplicação

### Passo 16.1: Verificar Logs

```bash
# Ver logs do Rails
sudo journalctl -u agendamento-exames -f

# Em outro terminal, ver logs do Nginx
sudo tail -f /var/log/nginx/error.log
```

### Passo 16.2: Acessar no Navegador

1. Abra o navegador
2. Acesse: `http://SEU_IP` ou `https://seu_dominio.com.br`
3. Deve aparecer a tela de login
4. Login:
   - **Email**: `admin@empresa.com.br`
   - **Senha**: `Admin@123`

---

## 🔧 Comandos Úteis de Manutenção

```bash
# Reiniciar aplicação
sudo systemctl restart agendamento-exames

# Ver logs em tempo real
sudo journalctl -u agendamento-exames -f

# Atualizar código do GitHub
cd ~/agendamento-exames
git pull origin main
bundle install
yarn install
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails assets:precompile
sudo systemctl restart agendamento-exames

# Acessar console Rails
cd ~/agendamento-exames
RAILS_ENV=production bundle exec rails console

# Ver status dos serviços
sudo systemctl status agendamento-exames
sudo systemctl status agendamento-exames-sidekiq
sudo systemctl status nginx
sudo systemctl status postgresql
sudo systemctl status redis-server
```

---

## 🐛 Solução de Problemas

### Erro 502 Bad Gateway

```bash
# Verificar se aplicação está rodando
sudo systemctl status agendamento-exames

# Ver últimos logs
sudo journalctl -u agendamento-exames -n 100

# Reiniciar
sudo systemctl restart agendamento-exames
```

### Erro de Conexão com Banco

```bash
# Verificar PostgreSQL
sudo systemctl status postgresql

# Testar conexão
psql -U deploy -d agendamento_exames_production -h localhost
```

### Assets não carregam

```bash
cd ~/agendamento-exames
RAILS_ENV=production bundle exec rails assets:clobber
RAILS_ENV=production bundle exec rails assets:precompile
sudo systemctl restart agendamento-exames
```

---

## 🔄 Configurar Backup Automático

```bash
# Criar diretório de backups
mkdir -p ~/backups

# Criar script de backup
nano ~/backup.sh
```

**Cole o seguinte:**

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/deploy/backups"

# Backup do banco
pg_dump -U deploy agendamento_exames_production > "$BACKUP_DIR/db_$DATE.sql"
gzip "$BACKUP_DIR/db_$DATE.sql"

# Limpar backups antigos (manter últimos 7)
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete

echo "Backup concluído: $DATE"
```

**Salvar e tornar executável:**

```bash
chmod +x ~/backup.sh

# Testar
./backup.sh

# Adicionar ao cron (backup diário às 2h)
crontab -e

# Adicione a linha:
0 2 * * * /home/deploy/backup.sh >> /home/deploy/backup.log 2>&1
```

---

## 📊 Monitoramento

```bash
# Uso de recursos
htop

# Espaço em disco
df -h

# Memória
free -h

# Processos Ruby
ps aux | grep puma
ps aux | grep sidekiq
```

---

## 🎉 Conclusão

Seu sistema está rodando na Vultr!

**Acesso:**
- 🌐 **URL**: http://SEU_IP ou https://seu_dominio.com.br
- 👤 **Login**: admin@empresa.com.br
- 🔑 **Senha**: Admin@123

**⚠️ IMPORTANTE:**
1. Altere a senha do admin após primeiro acesso
2. Configure backups regulares
3. Monitore os logs periodicamente
4. Mantenha o sistema atualizado

**🔗 Links Úteis:**
- Repositório: https://github.com/cmscheffer/agendamento-exames
- Painel Vultr: https://my.vultr.com/
- Mailgun: https://app.mailgun.com/

---

**Desenvolvido para**: Sistema de Agendamento de Exames Ocupacionais  
**Versão**: 1.0  
**Última atualização**: Janeiro 2025