# 🚀 Portfólio DevOps — Roberto Rigo

> Currículo/portfólio profissional com pipeline CI/CD completo, conteinerização Docker e deploy automatizado no GitHub Pages.

## 🌐 Site em Produção

**[https://github.com/xariote/ds881-curriculo-grr20240574]
---

## 🗂️ Estrutura do Projeto

```
portfolio/
├── .github/
│   └── workflows/
│       └── main.yml          # Pipeline CI/CD (Lint → Build → Deploy)
├── src/
│   ├── index.html            # Página principal do portfólio
│   ├── css/
│   │   └── style.css         # Estilos
│   └── js/
│       └── main.js           # Animações e interatividade
├── Dockerfile                # Imagem para desenvolvimento local
├── docker-compose.yml        # Orquestra o ambiente de dev
├── .gitignore
└── README.md
```

---

## 🐳 Executando Localmente com Docker

### Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) instalado
- [Docker Compose](https://docs.docker.com/compose/install/) (já incluso no Docker Desktop)

> Nenhuma instalação de Node.js ou outras dependências é necessária na sua máquina!

### Passo a passo

**1. Clone o repositório**

```bash
git clone https://github.com/xariote/ds881-curriculo-grr20240574.git
cd ds881-curriculo-grr20240574
```

**2. Suba o ambiente de desenvolvimento**

```bash
docker compose up --build
```

**3. Acesse o site**

Abra seu navegador em: **[http://localhost:8080](http://localhost:8080)**

### Hot Reload ativado ✅

Qualquer alteração salva nos arquivos dentro de `src/` será refletida automaticamente no navegador, sem precisar reiniciar o container. Isso é possível graças ao **bind mount** configurado no `docker-compose.yml`:

```yaml
volumes:
  - ./src:/app/src   # Código local → diretório de trabalho do container
```

### Parar o ambiente

```bash
docker compose down
```

### Verificar se está rodando

```bash
docker compose ps
# ou
curl http://localhost:8080
```

---

## ⚙️ Pipeline CI/CD (GitHub Actions)

O workflow em `.github/workflows/main.yml` executa automaticamente em **todo Pull Request** e **push na `main`**:

```
Pull Request aberto
        │
        ▼
┌───────────────┐
│  🔍 Job 1     │  Lint & Static Analysis
│               │  • HTMLHint (HTML)
│               │  • Stylelint (CSS)
│               │  • Verificação de arquivos obrigatórios
└───────┬───────┘
        │ (se aprovado)
        ▼
┌───────────────┐
│  🏗️ Job 2    │  Build
│               │  • Validação de HTML (tidy)
│               │  • Build da imagem Docker
│               │  • Smoke test do container
└───────┬───────┘
        │ (se aprovado + merge na main)
        ▼
┌───────────────┐
│  🚀 Job 3     │  Deploy
│               │  • Publicação no GitHub Pages
└───────────────┘
```

> O **Job 3 (Deploy)** só é executado em pushes na `main`. PRs executam apenas Lint e Build.

---

## 🔒 Proteção da Branch `main`

A branch `main` está configurada como protegida para garantir a qualidade do código. Segue a configuração aplicada:

### Como configurar (passo a passo)

1. Acesse **Settings → Branches** no seu repositório
2. Clique em **Add branch ruleset** (ou "Add rule" na UI clássica)
3. Em **Branch name pattern**, digite: `main`
4. Ative as seguintes opções:

| Configuração | Valor |
|---|---|
| Require a pull request before merging | ✅ Ativado |
| Require status checks to pass | ✅ Ativado |
| Status checks obrigatórios | `lint`, `build` |
| Require branches to be up to date | ✅ Ativado |
| Do not allow bypassing the above settings | ✅ Ativado |
| Block force pushes | ✅ Ativado |

### Configuração via GitHub CLI

```bash
# Criar branch ruleset via API
gh api repos/:owner/:repo/rulesets \
  --method POST \
  --field name="Protect main" \
  --field target="branch" \
  --field enforcement="active" \
  --field conditions='{"ref_name":{"include":["refs/heads/main"],"exclude":[]}}' \
  --field rules='[
    {"type":"pull_request","parameters":{"required_approving_review_count":0}},
    {"type":"required_status_checks","parameters":{"required_status_checks":[{"context":"lint"},{"context":"build"}],"strict_required_status_checks_policy":true}},
    {"type":"non_fast_forward"}
  ]'
```

### Prints da configuração

> **Nota:** Após aplicar as configurações, adicione aqui os prints das telas de proteção de branch do seu repositório. Você pode capturá-los em:
> - `Settings → Branches → Branch protection rules`
>
> Exemplo do que deve aparecer:
>
> ```
> Branch protection rule: main
> ✅ Require a pull request before merging
> ✅ Require status checks to pass before merging
>     - lint (required)
>     - build (required)
> ✅ Require branches to be up to date before merging
> ✅ Block force pushes
> ```

---

## 🌿 Fluxo de Trabalho Git

Este projeto segue o padrão **Conventional Commits** e proíbe push direto na `main`.

### Criar uma feature

```bash
# 1. Crie uma branch a partir da main
git checkout -b feat/minha-feature

# 2. Faça suas alterações e commit
git add .
git commit -m "feat: adiciona seção de certificações"

# 3. Envie a branch para o GitHub
git push origin feat/minha-feature

# 4. Abra um Pull Request no GitHub
# O pipeline rodará automaticamente. Só é possível fazer merge
# após todos os jobs passarem (✅ lint + ✅ build).
```

### Prefixos de commit (Conventional Commits)

| Prefixo | Uso |
|---|---|
| `feat:` | Nova funcionalidade |
| `fix:` | Correção de bug |
| `ci:` | Mudanças no pipeline CI/CD |
| `docs:` | Documentação |
| `style:` | Formatação, CSS |
| `refactor:` | Refatoração sem mudança funcional |
| `chore:` | Tarefas de manutenção |

---

## 🛠️ Stack Técnica

| Camada | Tecnologia |
|---|---|
| Site | HTML5 / CSS3 / JavaScript (vanilla) |
| Dev local | Docker + live-server (hot reload) |
| CI/CD | GitHub Actions |
| Hosting | GitHub Pages |
| Lint | HTMLHint + Stylelint |

---

## 📋 Checklist de Entrega

- [x] Site estático funcional (HTML/CSS/JS)
- [x] `Dockerfile` com imagem base adequada (`node:20-alpine`)
- [x] `docker-compose.yml` com bind mount e porta `8080`
- [x] Hot reload funcionando via live-server
- [x] Branch `main` protegida
- [x] Fluxo via Pull Request obrigatório
- [x] Pipeline CI/CD com Lint, Build e Deploy
- [x] Mensagens de commit seguindo Conventional Commits
- [x] Deploy automatizado no GitHub Pages
- [x] README com instruções completas

---

*Desenvolvido como projeto da disciplina de Tópicos Especiais Em Tecnologias Emergentes — 2025*
