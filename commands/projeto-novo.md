---
description: Preparar um projeto (novo ou já existente) pra trabalhar barato — CLAUDE.md enxuto e .claude/
allowed-tools: Bash(ls:*), Bash(git:*), Bash(cat:*), Bash(wc:*), Bash(find:*), Read, Write, Edit, Grep, Glob
---

## O que já existe aqui
!`ls -a 2>/dev/null | head -30`

## CLAUDE.md atual
!`wc -l CLAUDE.md 2>/dev/null || echo "(não existe)"`

## Git
!`git log --oneline -5 2>/dev/null || echo "(sem git)"`

---

Prepare este projeto. Use a skill **`claude-md`** para o formato e os tetos.

**Passo 1 — pergunte só o que não dá pra descobrir lendo.** Leia o repositório primeiro;
depois pergunte, de uma vez só, no máximo quatro coisas:

- O que é o projeto, em uma frase de negócio (não de tecnologia).
- O que **não se reabre** — stack fechada, decisões já tomadas.
- Como roda, de verdade (o comando que ela digita).
- Tem dado real de cliente envolvido? Isso mudaria tudo sobre git e logs.

**Passo 2 — crie:**

- `CLAUDE.md`, **teto de 60 linhas**. Ele é pago em toda sessão deste projeto: cada linha
  precisa se justificar. Regra e mapa entram; histórico e o que o `git log` já conta, não.
- `.claude/.gitignore` com `checkpoint.md` e `ideias.md`.
- `AGENTS.md`, espelho do `CLAUDE.md` pra ferramentas que não o leem (Antigravity, Gemini
  CLI), **teto de 25 linhas** — formato no `/checkpoint`, que o mantém atualizado daí em
  diante. Pule se o projeto só vai ser tocado pelo Claude Code.
- `.claude/launch.json` se houver servidor de desenvolvimento.

**Passo 3 — decida junto com ela, sem decidir sozinho:** este projeto merece
desenvolvimento por spec (`.specify/`) ou é pequeno demais pra isso? Spec cara demais mata
projeto pequeno; projeto grande sem spec vira retrabalho. O critério é se existe **regra de
negócio que alguém de fora precisa entender**.

**Passo 4 — feche com `/checkpoint`**, pra este projeto já nascer com retomada barata.

Se o projeto **já existia** e já tinha `CLAUDE.md`, não reescreva por cima: audite contra a
skill `claude-md`, mostre o que sobra e o que falta, e só mexa depois que ela aprovar.
