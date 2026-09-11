#!/usr/bin/env bash
# UserPromptSubmit — captura ideia sem gastar token.
# Prompt que começa com "ideia:" é gravado em arquivo e APAGADO (exit 2),
# então ele nunca entra no contexto do modelo. Qualquer outro prompt: exit 0 mudo.
# Bash puro + jq + git de propósito: hook não enxerga o nvm (node: not found).
set -uo pipefail
PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

entrada=$(cat)
prompt=$(printf '%s' "$entrada" | jq -r '.prompt // ""')
cwd=$(printf '%s' "$entrada" | jq -r '.cwd // ""')
[ -n "$cwd" ] || cwd=$PWD

# Só reage ao prefixo. Aceita espaço antes e maiúscula/minúscula.
shopt -s nocasematch
[[ "$prompt" =~ ^[[:space:]]*ideia: ]] || exit 0
shopt -u nocasematch

texto=$(printf '%s' "$prompt" | sed -E 's/^[[:space:]]*[Ii][Dd][Ee][Ii][Aa]:[[:space:]]*//')

# Segundo rótulo "plugin:" manda pro backlog do próprio mona-dev.
destino=""
shopt -s nocasematch
if [[ "$texto" =~ ^plugin: ]]; then
  texto=$(printf '%s' "$texto" | sed -E 's/^[Pp][Ll][Uu][Gg][Ii][Nn]:[[:space:]]*//')
  destino="/home/monalisa/projetos/mona-dev/IDEIAS.md"
fi
shopt -u nocasematch

if [ -z "$destino" ]; then
  if [ -d "$cwd/.claude" ]; then
    destino="$cwd/.claude/ideias.md"
    # o arquivo de ideias e o checkpoint nunca sobem pro git
    gi="$cwd/.claude/.gitignore"
    [ -f "$gi" ] || printf 'checkpoint.md\nideias.md\n' > "$gi"
  else
    destino="/home/monalisa/.claude/ideias.md"
  fi
fi

if [ -z "${texto// }" ]; then
  echo "💡 escreva a ideia depois dos dois-pontos — ex.: ideia: reusar a tela de conferência no F3" >&2
  exit 2
fi

mkdir -p "$(dirname "$destino")"
[ -f "$destino" ] || printf '# Ideias não triadas\n\nCapturadas por `ideia: ...`. Triagem com `/ideias`.\n\n' > "$destino"

branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "-")
projeto=$(basename "$cwd")
printf -- '- [ ] %s · %s · %s — %s\n' "$(date '+%d/%m %H:%M')" "$projeto" "$branch" "$texto" >> "$destino"

fila=$(grep -c '^- \[ \]' "$destino" 2>/dev/null || echo 0)
echo "💡 anotada · $fila na fila · $(basename "$(dirname "$destino")")/$(basename "$destino") · triagem: /ideias" >&2
exit 2
