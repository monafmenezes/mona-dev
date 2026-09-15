---
description: Gravar o estado da sessão antes de compactar, limpar ou parar
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(cat:*), Bash(date:*), Bash(ls:*), Read, Write, Edit
---

## Estado do git
!`git status --short 2>/dev/null | head -30 || echo "(não é repositório git)"`

## O que mudou
!`git diff --stat 2>/dev/null | tail -20 || true`

## Commits desta leva
!`git log --oneline -5 2>/dev/null || true`

## Do checkpoint anterior, só o que é cumulativo
As seções *Onde parei*, *O que mudou* e *Próximo passo* do anterior não vêm de
propósito: são substituídas por esta sessão. Estas três se acumulam — recopie o
que ainda vale e some o novo.
!`awk '/^## (Decisões|Aguardando|Armadilhas)/{p=1} /^## (Onde parei|O que mudou|Próximo passo)/{p=0} p' .claude/checkpoint.md 2>/dev/null || echo "(primeiro checkpoint deste projeto)"`

## Espelho pras outras ferramentas
Fonte e espelhos, com a data de cada um — espelho mais velho que a fonte está desatualizado.
!`ls -lo --time-style=+%d/%m\ %H:%M CLAUDE.md AGENTS.md GEMINI.md 2>/dev/null | awk '{print $NF, $(NF-2), $(NF-1)}' || echo "(nenhum)"`

## Ideias não triadas
!`grep '^- \[ \]' .claude/ideias.md 2>/dev/null || echo "(fila vazia)"`

---

Grave `.claude/checkpoint.md` **substituindo** o anterior (o histórico está no git e na
memória; checkpoint é foto do agora, não diário). Crie `.claude/.gitignore` com
`checkpoint.md` e `ideias.md` se ainda não existir.

Formato fixo, **teto de 40 linhas**:

```markdown
# Checkpoint — <projeto> · <data>

## Onde parei
<um parágrafo. O que estava sendo feito e por quê.>

## O que mudou
<arquivo:linha → o quê e POR QUÊ. Só o que a pessoa não descobriria lendo o git diff.>

## Decisões que não se reabrem
<o que foi decidido nesta sessão e não deve voltar à mesa. Com o motivo.>

## Próximo passo
<acionável, já com o comando ou o arquivo. Esta seção é a que o hook de retomada lê.>

## Aguardando ela
<decisões que são dela e travam o avanço. Vazio é resposta válida.>

## Armadilhas
<o que custou tempo e vai custar de novo se esquecer.>
```

Depois de gravar:

1. **Espelho pras outras ferramentas** (Antigravity, Gemini CLI — elas não leem
   `CLAUDE.md`). A fonte é sempre o `CLAUDE.md`; o espelho é ponteiro, não cópia.
   - Sem `CLAUDE.md` no projeto: não invente um espelho. Diga em uma linha que
     `/projeto-novo` cria a fonte primeiro, e siga.
   - Não existe `AGENTS.md` nem `GEMINI.md`: crie **`AGENTS.md`** (é o nome que o
     Antigravity lê; o Gemini CLI também aceita). Só crie o `GEMINI.md` se ela pedir.
   - Já existe um ou os dois: reescreva **cada um que existir**, e só se o `CLAUDE.md`
     tiver mudado desde a última vez — espelho igual não se regrava.
   - **Nunca** copie estado de sessão pra dentro dele: `AGENTS.md` é versionado, e o
     estado vive no `.claude/checkpoint.md`, que é ignorado no git. O espelho só
     *aponta* pro checkpoint.

   Formato fixo, **teto de 25 linhas** — projeto com lei própria (regras invioláveis,
   privacidade não-negociável) passa disso, pelo mesmo motivo que o `CLAUDE.md` dele passa
   de 60. O que **não** legitima passar: histórico, estado e detalhe de domínio.

   ```markdown
   # <projeto>

   <a frase de negócio do CLAUDE.md>

   Espelho de `CLAUDE.md` pra ferramentas que não o leem. **A fonte é o `CLAUDE.md`** —
   mudou aqui sem mudar lá, vale o de lá.

   ## Como rodar
   <o comando de verdade>

   ## O que não se reabre
   <as decisões fechadas do CLAUDE.md, uma linha cada>

   ## Armadilhas
   <as que já custaram tempo, uma linha cada>

   ## Estado da sessão
   `.claude/checkpoint.md` (fora do git) tem onde parei, o próximo passo e o que está
   aguardando decisão. Leia antes de começar.
   ```

2. **Memória de longo prazo só quando houver o quê** (`~/.claude/projects/-home-monalisa/memory/`):
   decisão de produto, feedback sobre como trabalhar, armadilha que vale pra outros
   projetos. Checkpoint é do *agora*; memória é do *sempre*. **Sessão de execução de
   task normalmente não gera nada disso** — não vá procurar o que gravar; se nada
   mudou no durável, diga "memória: nada novo" e siga. É o passo mais caro deste
   comando, e o que menos vezes se justifica.
3. **Ideias: só listar, nunca triar.** Se houver fila, diga quantas são e que `/ideias`
   faz a triagem. **Não marque `[x]`, não descarte, não decida destino** — a triagem é
   dela, acontece no `/ideias`, com ela olhando. Ideia descartada sem ela ver é ideia
   perdida.
4. **Atrito repetido?** Se nesta sessão você teve que explicar algo pela segunda vez, ou
   ela pediu algo que já pediu em outro projeto, proponha virar comando ou skill do
   `mona-dev` — uma linha, sem desenvolver. O gatilho é repetição, não "seria legal".
5. Feche dizendo se vale `/compact`, `/clear` ou sessão nova, e por quê.

⚠️ **Nunca grave dado real de cliente** (nome, CPF, telefone, endereço, valor de
contrato real) no checkpoint — ele vive dentro do projeto.
