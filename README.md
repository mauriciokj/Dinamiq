# DinamiQ 📊

**Sistema de Enquetes em Tempo Real**

DinamiQ é uma plataforma moderna de enquetes interativas que permite criar, compartilhar e participar de votações com atualizações em tempo real. Desenvolvido com Rails 8.0.1 e ActionCable, oferece uma experiência dinâmica e engajante para coleta de opiniões e feedback.

## 🚀 Funcionalidades Principais

- ✅ **Criação de Enquetes**: Interface intuitiva para criar enquetes com múltiplas opções
- 🔗 **Compartilhamento via Token**: Sistema de tokens únicos de 8 caracteres para fácil compartilhamento
- ⚡ **Votação em Tempo Real**: Atualizações instantâneas dos resultados via WebSocket
- 🛡️ **Prevenção de Voto Duplo**: Sistema de identificação única por usuário
- 📊 **Visualização de Resultados**: Gráficos e estatísticas em tempo real
- 📱 **Design Responsivo**: Interface otimizada para desktop e mobile
- 🔍 **Verificação de Status**: Consulta se usuário já participou da enquete

## 🛠️ Stack Tecnológico

- **Backend**: Ruby on Rails 8.0.1 (API Mode)
- **Banco de Dados**: PostgreSQL
- **Cache**: Solid Cache (database-backed)
- **Filas**: Solid Queue (background jobs)
- **WebSocket**: ActionCable com Solid Cable
- **Deploy**: Kamal + Docker
- **Testes**: Minitest
- **Gems Adicionais**: RQRCode (geração de QR codes)

## 📋 Pré-requisitos

- Ruby 3.3.0+
- PostgreSQL 14+
- Docker (para deploy)
- Node.js (para assets, se necessário)

## 🔧 Instalação e Configuração

### 1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/DinamiQ.git
cd DinamiQ
```

### 2. Instale as dependências
```bash
bundle install
```

### 3. Configure o banco de dados
```bash
# Configure as credenciais no config/database.yml
rails db:create
rails db:migrate
rails db:seed
```

### 4. Configure as variáveis de ambiente
```bash
# Copie o arquivo de exemplo (se existir)
cp .env.example .env

# Configure as variáveis necessárias:
# DATABASE_URL=postgresql://username:password@localhost/dinamiq_development
# RAILS_MASTER_KEY=sua_master_key
```

## 🚀 Como Executar

### Desenvolvimento
```bash
# Inicie o servidor Rails
rails server

# Em outro terminal, inicie o ActionCable (se necessário)
# O ActionCable já está integrado no Rails 8
```

A aplicação estará disponível em `http://localhost:3000`

### Produção com Docker
```bash
# Build da imagem
docker build -t dinamiq .

# Execute o container
docker run -p 3000:3000 dinamiq
```

### Deploy com Kamal
```bash
# Configure o deploy.yml
kamal setup

# Deploy da aplicação
kamal deploy
```

## 📚 Documentação da API

### Endpoints Principais

#### Listar Enquetes
```http
GET /polls
```

**Resposta:**
```json
[
  {
    "id": 1,
    "title": "Qual sua linguagem favorita?",
    "token": "a1b2c3d4",
    "created_at": "2025-01-15T10:00:00Z",
    "options": [
      {
        "id": 1,
        "content": "JavaScript",
        "votes_count": 15
      },
      {
        "id": 2,
        "content": "Python",
        "votes_count": 23
      }
    ]
  }
]
```

#### Criar Enquete
```http
POST /polls
Content-Type: application/json
```

**Requisição:**
```json
{
  "poll": {
    "title": "Qual sua linguagem favorita?",
    "options_attributes": [
      { "content": "JavaScript" },
      { "content": "Python" },
      { "content": "Ruby" }
    ]
  }
}
```

#### Visualizar Enquete
```http
GET /polls/:token
```

#### Votar na Enquete
```http
POST /polls/:token/vote
Content-Type: application/json
```

**Requisição:**
```json
{
  "option_id": 1,
  "user_uid": "unique-user-identifier"
}
```

#### Verificar Voto
```http
GET /polls/:token/check_vote?user_uid=unique-user-identifier
```

**Resposta:**
```json
{
  "voted": true,
  "option_id": 1
}
```

### WebSocket (ActionCable)

Conecte-se ao canal para receber atualizações em tempo real:

```javascript
// Conexão WebSocket
const cable = ActionCable.createConsumer('ws://localhost:3000/cable');

// Subscrever ao canal da enquete
const subscription = cable.subscriptions.create(
  { channel: 'PollChannel', token: 'a1b2c3d4' },
  {
    received(data) {
      // Atualizar interface com novos resultados
      console.log('Novos resultados:', data);
    }
  }
);
```

## 🗄️ Estrutura do Banco de Dados

### Tabelas Principais

#### polls
- `id` (bigint, PK)
- `title` (string) - Título da enquete
- `token` (string, unique) - Token único de 8 caracteres
- `created_at` (datetime)
- `updated_at` (datetime)

#### options
- `id` (bigint, PK)
- `poll_id` (bigint, FK) - Referência à enquete
- `content` (string) - Conteúdo da opção
- `votes_count` (integer, default: 0) - Contador de votos
- `created_at` (datetime)
- `updated_at` (datetime)

#### votes
- `id` (bigint, PK)
- `poll_id` (bigint, FK) - Referência à enquete
- `option_id` (bigint, FK) - Referência à opção
- `user_uid` (string) - Identificador único do usuário
- `created_at` (datetime)
- `updated_at` (datetime)

### Relacionamentos
- `Poll` has_many `Options` (dependent: :destroy)
- `Poll` has_many `Votes` (dependent: :destroy)
- `Option` belongs_to `Poll`
- `Option` has_many `Votes` (dependent: :destroy)
- `Vote` belongs_to `Poll`
- `Vote` belongs_to `Option`

## 🧪 Testes

Execute a suíte de testes:

```bash
# Todos os testes
rails test

# Testes específicos
rails test test/models/
rails test test/controllers/
rails test test/channels/

# Com coverage (se configurado)
rails test COVERAGE=true
```

### Estrutura de Testes
- **Models**: `test/models/` - Testes de validação e relacionamentos
- **Controllers**: `test/controllers/` - Testes de endpoints da API
- **Channels**: `test/channels/` - Testes do ActionCable
- **Integration**: `test/integration/` - Testes de fluxo completo

## 🚀 Deploy

### Configuração do Kamal

O projeto está configurado para deploy com Kamal. Principais arquivos:

- `config/deploy.yml` - Configuração principal do deploy
- `Dockerfile` - Imagem Docker da aplicação
- `.kamal/` - Hooks e secrets do Kamal

### Comandos de Deploy

```bash
# Primeira configuração
kamal setup

# Deploy da aplicação
kamal deploy

# Rollback para versão anterior
kamal rollback

# Logs da aplicação
kamal app logs

# Status dos serviços
kamal app details
```

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Padrões de Código

- Siga as convenções do Ruby/Rails
- Execute `rubocop` antes de fazer commit
- Mantenha cobertura de testes acima de 90%
- Documente novas funcionalidades

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 Suporte

- 📧 Email: suporte@dinamiq.com
- 🐛 Issues: [GitHub Issues](https://github.com/seu-usuario/DinamiQ/issues)
- 📖 Documentação: [Wiki do Projeto](https://github.com/seu-usuario/DinamiQ/wiki)

## 🎯 Roadmap

- [ ] Interface web completa (React/Vue.js)
- [ ] Autenticação de usuários
- [ ] Enquetes com tempo limite
- [ ] Exportação de resultados (PDF/CSV)
- [ ] Integração com redes sociais
- [ ] API de webhooks
- [ ] Dashboard de analytics
- [ ] Temas personalizáveis

---

**Desenvolvido com ❤️ usando Ruby on Rails**
