# Guia do mona-dev — a colinha

Cinco comandos e uma palavrinha mágica. Se você lembrar só de uma coisa, lembre do
`ideia:` — é a única que custa **zero**.

## A tabela

| Você digita | Quando | O que acontece |
|---|---|---|
| `ideia: <texto>` | surgiu um insight no meio do trabalho | some da tela, vai pra um arquivo, **nada** é enviado pro Claude. Zero token, zero desvio de assunto |
| `/checkpoint` | antes de parar, compactar ou limpar | grava onde você parou, o que decidiu e o próximo passo em `.claude/checkpoint.md` |
| `/retomar` | ao voltar num projeto | ele te conta o estado em ≤15 linhas, **sem reler o repositório** |
| `/ideias` | quando a fila incomodar | triagem: cada ideia vira issue, vira spec, ou morre com o motivo escrito |
| `/prompt <tipo> <o quê>` | antes de abrir sessão nova pra uma tarefa | monta o texto pra colar, já com os arquivos certos e o modelo sugerido |
| `/projeto-novo` | projeto novo, ou um antigo bagunçado | cria o `CLAUDE.md` enxuto e o `.claude/` |

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

O modelo sugerido vem junto, com o motivo: se as cinco partes ficaram concretas, **Sonnet
resolve**. Se sobrou "descubra", é Opus — delegar ambiguidade pro modelo barato sai mais
caro, porque volta errado.

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
