# Guia do mona-dev — a colinha

Seis comandos e uma palavrinha mágica. Se você lembrar só de uma coisa, lembre do
`ideia:` — é a única que custa **zero**.

## A tabela

| Você digita | Quando | O que acontece |
|---|---|---|
| `ideia: <texto>` | surgiu um insight no meio do trabalho | some da tela, vai pra um arquivo, **nada** é enviado pro Claude. Zero token, zero desvio de assunto |
| `/checkpoint` | antes de parar, compactar ou limpar | grava onde você parou, o que decidiu e o próximo passo em `.claude/checkpoint.md` — e mantém o `AGENTS.md` em dia |
| `/retomar` | ao voltar num projeto | ele te conta o estado em ≤15 linhas, **sem reler o repositório** |
| `/ideias` | quando a fila incomodar | triagem: cada ideia vira issue, vira spec, ou morre com o motivo escrito |
| `/prompt <tipo> <o quê>` | antes de começar qualquer passo novo | monta o texto pra colar, já com os arquivos certos e o modelo sugerido — tipos: `spec`, `plano`, `tasks`, `task`, `tela-nova`, `endpoint`, `bug`, `revisao` |
| `/projeto-novo` | projeto novo, ou um antigo bagunçado | cria o `CLAUDE.md` enxuto e o `.claude/` |
| `/revisao-mecanica [caminho]` | antes de commitar, uma olhada rápida | só padrão de texto no diff — segredo, debug esquecido, conflito não resolvido, arquivo indevido. Roda em Haiku, de propósito. **Não** é o `/code-review`: não acha bug nem sugere design, só o que qualquer um confirmaria olhando a linha |

E uma coisa que acontece **sozinha**: depois de um `/compact` ou `/clear`, a retomada
aparece na tela sem você pedir — mas só se aquele projeto tiver checkpoint. Projeto sem
checkpoint não mostra nada e não custa nada.

## Ligar num projeto que já existe

Não precisa instalar nada por projeto — o plugin está no escopo de usuário, então já vale
em todos eles. O que falta em cada um é só a **semente**, uma vez:

1. Abra o projeto e rode **`/checkpoint`**. Ele cria o `.claude/checkpoint.md` e o
   `.claude/.gitignore`. Só a partir daí a retomada automática funciona ali — antes do
   primeiro checkpoint o hook fica mudo de propósito.
2. Se o projeto não tiver `CLAUDE.md`, ou tiver um inchado, rode **`/projeto-novo`**: em
   projeto que já existe ele **audita antes de mexer** e espera sua aprovação.

O `ideia:` funciona em qualquer pasta desde já, sem semente nenhuma.

## O dia típico

```
abriu o projeto      →  /retomar
trabalhando          →  ideia: dá pra reusar a tela de conferência no F3
contexto pesando     →  /checkpoint  e depois  /compact
tarefa acabou        →  /checkpoint  e depois  /clear
vai parar por hoje   →  /checkpoint
```

## `ideia:` — a que mais paga

Você digita no meio de qualquer conversa:

```
ideia: o teto de distância devia valer também pro treino longo
```

Aparece só `💡 anotada · 3 na fila`. O Claude **não recebe** esse texto — ele é apagado
antes de chegar. Por isso não interrompe o que estava sendo feito e não entra na conta.

Duas variações:

- `ideia: plugin: <texto>` — vai pro backlog do próprio mona-dev, quando a ideia é sobre
  **a ferramenta**, não sobre o projeto.
- Fora de um projeto, cai em `~/.claude/ideias.md`. Nunca se perde.

⚠️ Não use `!` como prefixo: no Claude Code `!` já é o modo bash.

## `/prompt` — pra onde vai a economia de verdade

`/prompt tela-nova cadastro de despesa` roda **na sessão que já tem contexto** e devolve um
texto colável com: o que fazer, os arquivos nomeados, o molde a seguir, o critério de
pronto e o que não tocar. Aí você abre uma sessão limpa, cola, e ela não precisa explorar
nada.

Vai desenvolver no Antigravity? Termine o pedido com **`pro antigravity`**: sai o mesmo
prompt, sem comando do Claude Code dentro, apontando o `AGENTS.md` e já pedindo as 5 linhas
de retorno que você cola aqui no `/checkpoint` depois.

O modelo sugerido vem junto, com o motivo: se as cinco partes ficaram concretas, **Sonnet
resolve**. Se sobrou "descubra", é Opus — delegar ambiguidade pro modelo barato sai mais
caro, porque volta errado.

### Qual tipo usar

O tipo só muda **o que eu vou perguntar e procurar** antes de escrever o prompt. Na dúvida,
olhe a coluna do meio: é ela que decide.

**Projeto com spec (o `acerto`)** — a fatia desce essa escada, um degrau por sessão:

| Tipo | Use quando a frase for… | Exemplo de como digitar |
|---|---|---|
| `spec` | "vou **escrever** o que essa fatia faz, ainda não é código" | `/prompt spec fatia 013 relatório anual` |
| `plano` | "a spec está fechada, agora decido **como** construir" | `/prompt plano 004` |
| `tasks` | "o plano está aprovado, agora quebro em passos" | `/prompt tasks 004` |
| `task` | "vou fazer a próxima task do `tasks.md`" | `/prompt task T017` · `/prompt task passo 5` · `/prompt task próxima` |

A diferença entre `tasks` e `task` é uma letra e muita coisa: **`tasks` escreve a lista inteira,
uma vez por fatia; `task` executa um item dela, e você vai digitar esse várias vezes.**

No `task`, `passo 5` pega o Passo inteiro — costuma ser o tamanho certo de uma sessão, porque
as tasks de um mesmo Passo compartilham contexto. E `próxima` pula o que está marcado como
bloqueado (🔒 e ⛓): se só sobrou bloqueio, eu digo quem está segurando em vez de gerar prompt.

**Projeto sem spec no meio** (PaceAI, Jarbas, portfólio):

| Tipo | Use quando a frase for… | Exemplo de como digitar |
|---|---|---|
| `tela-nova` | "preciso de uma tela/componente que ainda não existe" | `/prompt tela-nova lançar despesa de turma` |
| `endpoint` | "preciso de uma rota de API nova" | `/prompt endpoint listar rodadas em aberto` |
| `bug` | "isso deveria funcionar e não funciona" | `/prompt bug o total do mês vem zerado` |
| `revisao` | "está pronto, quero alguém olhando com régua" | `/prompt revisao a fatia 004 contra a constitution` |

Três enganos fáceis de cometer:

- **`task` × `tela-nova`.** Se o trabalho já está escrito num `tasks.md`, é **sempre `task`**
  — mesmo que o resultado seja uma tela. O `task` já traz os portões da fatia e a task irmã
  como molde; o `tela-nova` não sabe que esse `tasks.md` existe. Use `tela-nova` só quando
  não há spec mandando.
- **`spec` × o resto.** `spec` é pra **decidir**, sem stack e sem arquivo de código. Se você
  já sabe o que construir, não é `spec`.
- **Pular o `plano`.** Dá pra pedir `tasks` com a spec pronta e sem plano, e sai lista — só
  que ela vai ter inventado modelo de dados e ordem de construção no caminho, escondido
  dentro das tasks, onde você não revisa. Se o degrau de trás estiver com buraco eu aviso
  antes de gerar.

Se você errar o tipo, não quebra nada: eu peço as informações que faltam antes de escrever.
E se faltar alguma das cinco partes, eu **pergunto na hora** — prompt com buraco vira
retrabalho na sessão seguinte, e aí a economia virou prejuízo.

## Onde ficam os arquivos

| Arquivo | O quê | Vai pro git? |
|---|---|---|
| `.claude/checkpoint.md` | estado do projeto agora | **não** |
| `.claude/ideias.md` | fila de ideias daquele projeto | **não** |
| `~/.claude/ideias.md` | ideias fora de projeto | não existe git ali |
| `~/projetos/mona-dev/IDEIAS.md` | ideias sobre a própria ferramenta | sim |

O `.claude/.gitignore` é criado sozinho na primeira ideia ou no primeiro checkpoint.

## Uma regra que não é comando

Sempre que um pedido seu se repetir em mais de um projeto, ou eu explicar a mesma coisa
duas vezes, eu **proponho** virar comando ou skill daqui — mas nunca no meio do seu
raciocínio: vai pro `IDEIAS.md` e aparece no `/checkpoint`. O gatilho é **repetição**,
nunca "seria legal".
