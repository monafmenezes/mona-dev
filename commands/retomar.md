---
description: Retomar o projeto de onde parou, sem reler o repositório
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(cat:*), Bash(grep:*)
---

## Checkpoint gravado
!`cat .claude/checkpoint.md 2>/dev/null || echo "(nenhum checkpoint neste projeto)"`

## Estado do git
!`git status --short 2>/dev/null | head -20 || echo "(não é repositório git)"`

## Últimos commits
!`git log --oneline -5 2>/dev/null || true`

## Ideias na fila
!`grep -c '^- \[ \]' .claude/ideias.md 2>/dev/null || echo 0`

---

Devolva a retomada em **no máximo 15 linhas**, nesta ordem:

1. Uma frase dizendo onde ela parou.
2. O que está sem commit, agrupado por assunto — não listar arquivo por arquivo.
3. O **próximo passo**, já acionável.
4. Se houver decisão aguardando ela, diga qual — isso não pode se perder entre sessões.
5. Se houver ideia na fila, uma linha só: quantas e que `/ideias` faz a triagem.

**Não chame nenhuma ferramenta.** Tudo que você precisa já está acima. Reler o
repositório "pra se situar" é exatamente o gasto que este comando existe pra evitar —
se faltar informação, diga o que falta em vez de ir buscar.

Se não havia checkpoint, diga isso em uma linha e ofereça rodar `/checkpoint` ao fim
desta sessão. Não invente o que ela estava fazendo.
