---
description: Gravar o estado da sessão antes de compactar, limpar ou parar
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(cat:*), Bash(date:*), Read, Write, Edit
---

## Estado do git
!`git status --short 2>/dev/null | head -30 || echo "(não é repositório git)"`

## O que mudou
!`git diff --stat 2>/dev/null | tail -20 || true`

## Commits desta leva
!`git log --oneline -10 2>/dev/null || true`

## Checkpoint anterior
!`cat .claude/checkpoint.md 2>/dev/null || echo "(primeiro checkpoint deste projeto)"`

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

1. **O que merece memória de longo prazo** (`~/.claude/projects/-home-monalisa/memory/`)
   sobe pra lá, não fica no checkpoint: decisão de produto, feedback sobre como
   trabalhar, armadilha que vale pra outros projetos. Checkpoint é do *agora*;
   memória é do *sempre*.
2. **Triagem das ideias** acima, se houver: cada uma vira issue, vira spec, ou é
   descartada com o motivo. Marque `[x]` nas resolvidas.
3. **Atrito repetido?** Se nesta sessão você teve que explicar algo pela segunda vez, ou
   ela pediu algo que já pediu em outro projeto, proponha virar comando ou skill do
   `mona-dev` — uma linha, sem desenvolver. O gatilho é repetição, não "seria legal".
4. Feche dizendo se vale `/compact`, `/clear` ou sessão nova, e por quê.

⚠️ **Nunca grave dado real de cliente** (nome, CPF, telefone, endereço, valor de
contrato real) no checkpoint — ele vive dentro do projeto.
