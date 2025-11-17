# README - Sistema de Agendamento de Exames Ocupacionais

## Descrição
Sistema web Ruby on Rails para gestão de agendamentos de exames ocupacionais, com autenticação, perfis de usuário (admin/solicitante) e envio de email.

## Funcionalidades

### Administrador
- Dashboard administrativo com estatísticas
- CRUD de Solicitantes
- CRUD de Unidades Responsáveis  
- CRUD de CNPJs
- Visualização de todos os agendamentos

### Solicitante
- Dashboard com seus agendamentos
- Criar novo agendamento com formulário completo
- Editar agendamentos
- Visualizar detalhes do agendamento
- Receber email de confirmação

## Requisitos
- Ruby 3.0.0+
- Rails 6.1.0+
- PostgreSQL
- Redis (para Sidekiq)

## Instalação

1. Clone o repositório
```bash
git clone [url-do-repositorio]
cd sistema-agendamento-exames
```

2. Instale as dependências
```bash
bundle install
```

3. Configure o banco de dados
```bash
rails db:create
rails db:migrate
```

4. Configure o Redis
```bash
redis-server
```

5. Configure as credenciais de email
```bash
rails credentials:edit
```

6. Inicie o servidor
```bash
rails server
```

## Configuração de Email

Configure no arquivo `config/credentials.yml.enc`:
```yaml
mailgun:
  api_key: sua_chave_api
  domain: seu_dominio.com.br

admin_email: admin@empresa.com.br
```

## Estrutura de Models

### User
- email, encrypted_password
- role (admin/solicitante)
- nome

### Solicitante  
- nome, email, telefone
- empresa, cargo
- belongs_to :user

### Unidade
- nome, cidade, estado
- endereco, telefone

### Cnpj
- numero, razao_social
- descricao, endereco

### Agendamento
- Dados completos do agendamento
- Relacionamentos com solicitante, unidade, cnpj
- Tipo de consulta (enum)

## Rotas Principais

- `/` - Página inicial
- `/users/sign_in` - Login
- `/admin/dashboard` - Dashboard admin
- `/solicitante/dashboard` - Dashboard solicitante
- `/solicitante/agendamentos` - Agendamentos

## Segurança
- Autenticação com Devise
- Autorização por roles (admin/solicitante)
- Validação de CPF com gem cpf_cnpj
- Proteção CSRF

## Background Jobs
- Envio de email com Sidekiq
- Processamento assíncrono

## Deploy
Configure as variáveis de ambiente:
- DATABASE_URL
- REDIS_URL  
- MAILGUN_API_KEY
- MAILGUN_DOMAIN
- SECRET_KEY_BASE

## Testes
```bash
rspec
```

## Contribuição
1. Faça fork do projeto
2. Crie sua feature branch
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## Licença
Este projeto está sob a licença MIT.