# Como Enviar o Projeto para o GitHub

## Opção 1: Criar Repositório Manualmente (Recomendado)

### 1. Criar o Repositório no GitHub
1. Acesse: https://github.com/new
2. **Repository name**: `solicitacao-agendamento`
3. **Description**: `Sistema de Agendamento de Exames Ocupacionais em Ruby on Rails`
4. **Visibility**: Public
5. **NÃO** inicialize com README, .gitignore ou license (já temos esses arquivos)
6. Clique em **Create repository**

### 2. Conectar e Enviar o Código
Após criar o repositório, execute os comandos abaixo:

```bash
cd /home/user/webapp

# Adicionar remote do GitHub
git remote add origin https://github.com/cmscheffer/solicitacao-agendamento.git

# Verificar branch
git branch -M main

# Enviar código
git push -u origin main
```

## Opção 2: Usar o Backup

Se preferir, você pode baixar o backup e fazer o upload localmente:

1. **Baixe o backup**: https://www.genspark.ai/api/files/s/0IKmSHHU

2. **Extraia o arquivo**:
```bash
tar -xzf solicitacao-agendamento-rails.tar.gz
cd webapp
```

3. **Crie o repositório no GitHub** (mesmos passos da Opção 1)

4. **Envie o código**:
```bash
git remote add origin https://github.com/cmscheffer/solicitacao-agendamento.git
git branch -M main
git push -u origin main
```

## Verificar após Upload

Após fazer o push, seu repositório estará disponível em:
**https://github.com/cmscheffer/solicitacao-agendamento**

## Conteúdo do Repositório

O repositório inclui:
- ✅ Sistema completo Ruby on Rails
- ✅ Models, Controllers e Views
- ✅ Autenticação com Devise
- ✅ Sistema de email
- ✅ Migrações de banco de dados
- ✅ Script de instalação
- ✅ Documentação completa
- ✅ Arquivos de configuração

## Próximos Passos

Após enviar para o GitHub:
1. Clone o repositório em seu ambiente local
2. Execute `./install.sh` para configurar
3. Configure suas credenciais no arquivo `.env`
4. Inicie o sistema com `rails server`