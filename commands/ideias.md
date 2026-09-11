---
description: Triar as ideias capturadas com "ideia:" — vira issue, vira spec, ou morre
allowed-tools: Bash(cat:*), Bash(grep:*), Read, Write, Edit
argument-hint: "[projeto | plugin | tudo]"
---

## Fila deste projeto
!`cat .claude/ideias.md 2>/dev/null || echo "(nenhuma)"`

## Fila solta (fora de projeto)
!`grep '^- \[ \]' ~/.claude/ideias.md 2>/dev/null || echo "(nenhuma)"`

## Fila do próprio plugin
!`grep '^- \[ \]' ~/projetos/mona-dev/IDEIAS.md 2>/dev/null || echo "(nenhuma)"`

---

Faça a triagem. Para **cada** ideia aberta, uma linha curta com o destino:

| Destino | Quando |
|---|---|
| **Agora** | resolve em minutos e destrava outra coisa |
| **Vira spec / issue** | é trabalho de verdade — diga em qual fatia ou arquivo entra |
| **Vira componente do `mona-dev`** | é atrito de processo, não de produto |
| **Morre** | deixou de fazer sentido, ou já foi resolvido por outro caminho |

Regras:

- **Uma linha por ideia.** Triagem que vira discussão deixa de ser triagem. Se uma ideia
  merece conversa, o destino dela é "vira spec" — a conversa acontece lá, não aqui.
- Marque `[x]` no arquivo e **anote o destino junto**, na mesma linha. Ideia descartada
  sem motivo escrito volta a ser capturada em duas semanas.
- Se o argumento foi `projeto`, `plugin` ou `tudo`, triar só essa fila.
- Fila vazia é ótima notícia: diga isso em uma linha e pare.
