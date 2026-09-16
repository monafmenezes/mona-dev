---
description: Checagem mecânica do diff — sem julgamento de bug, só o que dá pra achar por padrão de texto. Barato de propósito, roda em Haiku.
allowed-tools: Bash(git diff:*), Bash(git status:*)
model: claude-haiku-4-5-20251001
argument-hint: "[caminho opcional — default é o diff atual]"
---

## Diff (staged + unstaged)
!`git diff HEAD -- ${ARGUMENTS:-.} 2>/dev/null | head -800 || echo "(sem diff — nada pra revisar)"`

## Arquivos novos, não rastreados
!`git status --porcelain 2>/dev/null | grep '^??' | head -30 || true`

---

Isto **não é o `/code-review`** — aqui não tem julgamento de bug, arquitetura ou
simplificação. É só padrão de texto, objetivo, que qualquer um confirmaria olhando a
mesma linha. Se a checagem exigir entender a intenção do código, não é desta lista —
deixe de fora e sugira `/code-review` pra isso.

Rode cada item contra o diff acima. Responda em lista curta, só o que achar — item sem
ocorrência **não aparece na resposta** (silêncio é o padrão, nada de "✅ tudo limpo" item
por item). Cite `arquivo:linha`.

1. **Marcador de conflito de merge não resolvido** — `<<<<<<<`, `=======` (fora de bloco
   de código legítimo), `>>>>>>>`.
2. **Debug esquecido** — `console.log`, `debugger`, `print(`, `var_dump(`, `dd(`,
   `binding.pry`, `pdb.set_trace()`, `breakpoint()`, `dump(`.
3. **Segredo em texto plano** — padrão de chave/token (`AKIA...`, `sk-...`,
   `-----BEGIN...KEY-----`), senha ou secret com valor literal ao lado (não variável de
   ambiente), `.env` real entrando no diff (não `.env.example`/`.env.sample`).
4. **Arquivo que não devia estar aqui** — `node_modules/`, `dist/`, `build/`, `.DS_Store`,
   `*.log`, cache de IDE, binário grande sem justificativa aparente no projeto.
5. **TODO / FIXME / XXX novo** — linha **adicionada** (`+`) com esse marcador; só listar,
   não é bloqueio.
6. **Whitespace** — linha só com espaços, mistura de tab e espaço na mesma indentação.

Se nada bateu em nenhum item: uma linha só, **"Nada mecânico encontrado."** — sem repetir
a lista.
