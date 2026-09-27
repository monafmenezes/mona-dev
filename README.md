# mona-dev

Plugin pessoal do Claude Code para **continuidade e economia de contexto** entre sessões.

O problema que ele resolve: o caro não é a resposta longa, é **redescobrir o que já se
sabia**. Sessão nova relê o repositório inteiro, `/compact` salva a conversa mas perde o
durável, e `/clear` não salva nada.

👉 **Como usar no dia a dia: [GUIA.md](GUIA.md).**

## O que tem dentro

| Componente | O que faz |
|---|---|
| `/checkpoint` | grava o estado do projeto em `.claude/checkpoint.md` antes de parar, e atualiza o `AGENTS.md` |
| `/retomar` | devolve o estado em ≤15 linhas, sem reler o repositório |
| `/ideias` | triagem da fila de ideias capturadas |
| `/prompt` | gera o prompt colável pra uma sessão limpa, com o modelo sugerido — ou despacha pro `executor` com `pro executor` |
| `/projeto-novo` | prepara um projeto: `CLAUDE.md` enxuto + `.claude/` |
| `/revisao-mecanica` | checagem de padrão de texto no diff (segredo, debug, conflito), roda em Haiku |
| agente `varredura` | busca larga só leitura, devolve só a conclusão — Haiku |
| agente `executor` | executa task com as cinco partes do `/prompt` — Sonnet |
| skill `economia-de-contexto` | réguas de modelo, compactação e delegação |
| skill `claude-md` | escrever e auditar `CLAUDE.md` |
| skill `plugin-do-projeto` | método pra criar plugin específico de um repo |
| hook `UserPromptSubmit` | captura `ideia: ...` por zero token |
| hook `SessionStart` | retomada automática depois de `/compact` e `/clear` |

## Decisões de desenho

- **A retomada é automática; o checkpoint não pode ser.** `SessionStart` consegue injetar
  contexto e aceita matcher em `compact|clear`. `PreCompact` não injeta e não chama modelo
  — hook roda script, não pensa. Escrever um bom checkpoint exige o modelo, então é comando.
- **Os hooks são bash puro + `jq` + `git`, sem `node`.** Hook não carrega o nvm: `node`
  vira `node: not found`.
- **Silêncio é o padrão.** Projeto sem checkpoint e sem ideia não imprime nada e sai 0.
  Plugin de economia que fala o tempo todo já falhou.
- **Injeção `!` nos comandos.** O estado do git chega junto com o pedido, em vez de custar
  idas e voltas de ferramenta. `/retomar` responde sem chamar ferramenta nenhuma.
- **`AGENTS.md` é espelho, não segunda fonte.** O Antigravity e o Gemini CLI não leem
  `CLAUDE.md`; o `/checkpoint` reescreve o `AGENTS.md` a partir dele. Estado de sessão
  nunca entra ali — `AGENTS.md` é versionado, o checkpoint não é, então o espelho só
  aponta pro checkpoint.
- **Skills magras.** A compactação devolve só os primeiros 5.000 tokens de cada skill —
  skill gorda custa mais e ainda chega cortada.

## Instalar

```bash
claude plugin install mona-dev@local --scope user
```

Precisa de `~/.claude/marketplaces/local.json` apontando pra esta pasta.

### ⚠️ Editar o repo não muda nada nas sessões

O plugin instalado roda de uma **cópia** em `~/.claude/plugins/cache/mona/mona-dev/<versão>/`,
congelada na hora da instalação — mesmo com o marketplace apontando pra esta pasta. Editar aqui
e rodar `/checkpoint` executa a versão velha, sem erro nenhum, e isso passa despercebido: em
set/2026 sete commits ficaram três dias fora das sessões desse jeito.

Depois de mexer nos comandos ou nas skills:

```bash
# 1. suba a versão em .claude-plugin/plugin.json
claude plugin update mona-dev@mona -y
# 2. reinicie o Claude Code
```

Conferir o que está valendo de verdade:

```bash
grep -l "<trecho que você acabou de escrever>" ~/.claude/plugins/cache/mona/mona-dev/*/commands/*.md
```

## Conferir o custo

```bash
claude plugin validate ~/projetos/mona-dev --strict
claude plugin details mona-dev
```

O `details` mostra o custo de token projetado. Orçamento: **abaixo de ~500 tokens sempre
ligados**. Se passar disso, o plugin falhou no próprio objetivo.
