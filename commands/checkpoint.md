---
description: Gravar o estado da sessão antes de compactar, limpar ou parar
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(cat:*), Bash(date:*), Read, Write, Edit
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

1. **Memória de longo prazo só quando houver o quê** (`~/.claude/projects/-home-monalisa/memory/`):
   decisão de produto, feedback sobre como trabalhar, armadilha que vale pra outros
   projetos. Checkpoint é do *agora*; memória é do *sempre*. **Sessão de execução de
   task normalmente não gera nada disso** — não vá procurar o que gravar; se nada
   mudou no durável, diga "memória: nada novo" e siga. É o passo mais caro deste
   comando, e o que menos vezes se justifica.
2. **Ideias: só listar, nunca triar.** Se houver fila, diga quantas são e que `/ideias`
   faz a triagem. **Não marque `[x]`, não descarte, não decida destino** — a triagem é
   dela, acontece no `/ideias`, com ela olhando. Ideia descartada sem ela ver é ideia
   perdida.
3. **Atrito repetido?** Se nesta sessão você teve que explicar algo pela segunda vez, ou
   ela pediu algo que já pediu em outro projeto, proponha virar comando ou skill do
   `mona-dev` — uma linha, sem desenvolver. O gatilho é repetição, não "seria legal".
4. Feche dizendo se vale `/compact`, `/clear` ou sessão nova, e por quê.

⚠️ **Nunca grave dado real de cliente** (nome, CPF, telefone, endereço, valor de
contrato real) no checkpoint — ele vive dentro do projeto.
