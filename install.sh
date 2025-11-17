#!/bin/bash

# Script de instalação do Sistema de Agendamento de Exames Ocupacionais
# Este script automatiza a configuração inicial do sistema

echo "🚀 Iniciando instalação do Sistema de Agendamento de Exames Ocupacionais..."

# Verificar se Ruby está instalado
if ! command -v ruby &> /dev/null; then
    echo "❌ Ruby não está instalado. Por favor, instale Ruby 3.0.0 ou superior."
    exit 1
fi

# Verificar versão do Ruby
RUBY_VERSION=$(ruby -v | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
echo "✅ Ruby $RUBY_VERSION encontrado"

# Instalar bundler se não estiver instalado
if ! command -v bundle &> /dev/null; then
    echo "📦 Instalando bundler..."
    gem install bundler
fi

# Instalar dependências
echo "📦 Instalando dependências..."
bundle install

# Verificar se PostgreSQL está rodando
if ! pg_isready -q; then
    echo "❌ PostgreSQL não está rodando. Por favor, inicie o PostgreSQL."
    exit 1
fi

# Criar e configurar banco de dados
echo "🗄️ Configurando banco de dados..."
rails db:create
rails db:migrate

# Verificar se Redis está rodando
if ! redis-cli ping &> /dev/null; then
    echo "❌ Redis não está rodando. Por favor, inicie o Redis."
    echo "💡 Você pode instalar o Redis com: brew install redis (macOS) ou apt-get install redis-server (Ubuntu)"
    exit 1
fi

# Criar usuário admin inicial
echo "👤 Criando usuário admin inicial..."
rails runner "
  if User.find_by(email: 'admin@empresa.com.br').nil?
    user = User.new(
      email: 'admin@empresa.com.br',
      password: 'admin123',
      nome: 'Administrador',
      role: :admin
    )
    user.save!
    puts '✅ Usuário admin criado com sucesso!'
    puts 'Email: admin@empresa.com.br'
    puts 'Senha: admin123'
  else
    puts '⚠️ Usuário admin já existe'
  end
"

# Configurar Sidekiq
echo "⚙️ Configurando Sidekiq..."
echo "Para iniciar o Sidekiq, execute: bundle exec sidekiq"

# Criar arquivo .env se não existir
if [ ! -f .env ]; then
    echo "📝 Criando arquivo .env..."
    cp .env.example .env
    echo "⚠️ Por favor, configure o arquivo .env com suas credenciais"
fi

echo ""
echo "🎉 Instalação concluída com sucesso!"
echo ""
echo "📋 Próximos passos:"
echo "1. Configure o arquivo .env com suas credenciais"
echo "2. Inicie o Sidekiq: bundle exec sidekiq"
echo "3. Inicie o servidor Rails: rails server"
echo ""
echo "🔗 Acesse o sistema em: http://localhost:3000"
echo "👤 Login admin: admin@empresa.com.br / admin123"
echo ""
echo "📝 Para criar um usuário solicitante, acesse: /admin/solicitantes após fazer login como admin"