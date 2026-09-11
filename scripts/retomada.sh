#!/usr/bin/env bash
# SessionStart (compact|clear) — devolve só o que o resumo do /compact não carrega:
# estado do git, próximo passo do checkpoint e fila de ideias.
# Silêncio total quando não há checkpoint nem ideia: sessão normal não paga nada.
# Bash puro + jq + git de propósito: hook não enxerga o nvm (node: not found).
set -uo pipefail
PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

entrada=$(cat)
cwd=$(printf '%s' "$entrada" | jq -r '.cwd // ""')
[ -n "$cwd" ] || cwd=$PWD

checkpoint="$cwd/.claude/checkpoint.md"
ideias="$cwd/.claude/ideias.md"

fila=0
[ -f "$ideias" ] && fila=$(grep -c '^- \[ \]' "$ideias" 2>/dev/null || echo 0)

# Nada gravado neste projeto: sai mudo, custo zero.
[ -f "$checkpoint" ] || [ "$fila" -gt 0 ] || exit 0

{
  echo "━━ retomada · $(basename "$cwd") ━━"

  if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "-")
    sujos=$(git -C "$cwd" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    echo "branch $branch · $sujos arquivo(s) sem commit"
  fi

  [ "$fila" -gt 0 ] && echo "💡 $fila ideia(s) não triada(s) — /ideias"

  if [ -f "$checkpoint" ]; then
    quando=$(date -r "$checkpoint" '+%d/%m %H:%M' 2>/dev/null || echo "?")
    echo
    echo "Próximo passo (checkpoint de $quando):"
    awk '/^#+ .*[Pp]róximo passo/{p=1;next} p&&/^#+ /{exit} p' "$checkpoint" \
      | grep -v '^[[:space:]]*$' | head -6
    echo
    echo "Completo: .claude/checkpoint.md · não releia o repo pra se situar."
  fi
} | head -15
exit 0
