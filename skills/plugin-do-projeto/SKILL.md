---
name: plugin-do-projeto
description: Método pra decidir e montar um plugin específico de um projeto (comandos, skills e monitores próprios daquele repo). Use quando um mesmo pedido se repetir dentro de um projeto, quando a Monalisa falar em criar plugin ou comando pra um projeto específico, ou quando um fluxo daquele projeto tiver passos fixos.
---

# Plugin de um projeto só

O `mona-dev` cuida do que vale em **todo** projeto. Quando o atrito é de **um** projeto,
ele merece plugin próprio — ex.: a parte de marketing do PaceAI (funil, AARRR, postagem),
ou o fluxo de contrato do Copiloto Formaturas.

## Quando vale (e quando não)

Vale quando **as três** forem verdade:

1. O pedido já se repetiu **pelo menos três vezes** naquele projeto.
2. Ele tem **passos fixos** — dá pra escrever a receita sem "depende".
3. A receita **não serve** pra outro projeto. Se serve, é `mona-dev`.

Não vale quando é só conhecimento sobre o projeto: isso é `CLAUDE.md` ou arquivo lido sob
demanda, não plugin.

## Onde mora

Dentro do próprio repositório, em `.claude/` (comandos em `.claude/commands/`, skills em
`.claude/skills/`) — carrega sozinho, só naquele projeto, não polui os outros e viaja junto
com o código. Plugin instalado só se for compartilhar com outra pessoa.

## O que fazer

1. **Nomeie as repetições** primeiro — as concretas, com data se possível. Sem isso, o
   plugin nasce de palpite.
2. Escolha a forma: **comando** para o que ela dispara (um fluxo com passos);
   **skill** para o que deve carregar sozinho quando o assunto aparece;
   **monitor** (`monitors.json`, com `"when": "on-skill-invoke:<skill>"`) para acompanhar
   log em segundo plano só durante a depuração.
3. Use **injeção `!`** pra trazer o estado junto com o comando, em vez de gastar idas e
   voltas de ferramenta.
4. Comece por **um** componente. Plugin que nasce com seis comandos morre com seis
   comandos não usados.

## Armadilha que já custou tempo

`claude plugin validate` **passa com o plugin quebrado**. Quem acusa é
`claude plugin list`, no campo *Status*. Um caso real: declarar `"hooks"` no `plugin.json`
duplica o `hooks/hooks.json` (que já carrega sozinho) e derruba o plugin **inteiro** —
comandos, skills e tudo. Depois de mexer, confira o status de carregamento, não só o validate.
