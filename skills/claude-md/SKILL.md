---
name: claude-md
description: Escrever ou auditar o CLAUDE.md de um projeto — o que entra, o que não entra, e o teto de linhas. Use quando for criar CLAUDE.md, quando um CLAUDE.md estiver grande demais, quando a Monalisa perguntar o que colocar nele, ou ao preparar um projeto novo.
---

# CLAUDE.md enxuto

Um `CLAUDE.md` é **pago em toda sessão daquele projeto**, para sempre. É o único arquivo do
repositório com esse custo. Então a régua não é "o que é útil" — é **"o que é útil a ponto
de valer ser relido toda vez"**.

**Alvo: 60 linhas.** Passou disso, o ônus da prova inverte: cada seção acima do
alvo precisa passar no teste da seção seguinte, uma por uma, explicitamente.

Projeto com **lei própria** — um conjunto de regras invioláveis que toda mudança
tem que respeitar — legitimamente passa do alvo, porque essas regras mudam a
primeira resposta de toda sessão. O `copiloto-formaturas` fechou em 137 linhas
por isso (8 regras de desenho + 6 decisões que não se reabrem), vindo de 383.
O que **não** legitima passar: histórico, estado e detalhe de domínio.

Quando a lei for grande, prefira **arquivo próprio com ponteiro** (como a
`constitution.md` do `acerto`) a inchar o `CLAUDE.md`.

## O que entra

1. **O que é o projeto** — uma frase, em linguagem de negócio.
2. **Mapa** — onde mora o quê, em tabela. Só o que não é óbvio pela estrutura de pastas.
3. **O que não se reabre** — stack fechada, decisões já tomadas. Isso evita a discussão
   que volta toda sessão, e é a linha que mais se paga.
4. **Como rodar** — o comando de verdade, incluindo o jeito errado que parece certo.
5. **Armadilhas que já custaram tempo** — as que vão custar de novo. Uma linha cada.
6. **Privacidade**, quando o projeto toca dado real: o que nunca pode entrar no repo,
   no log, no erro.
7. **Ponteiros** — `@caminho` ou uma linha dizendo onde está o resto. Ponteiro é barato;
   conteúdo é caro.

## O que NÃO entra

| Não entra | Onde vive |
|---|---|
| Histórico do que foi feito | `git log` e o checkpoint |
| Estado atual, pendências | `.claude/checkpoint.md` |
| Regra de negócio detalhada | spec / `.specify/` |
| Achados de levantamento | arquivo próprio, lido sob demanda |
| O que o código já diz | o código |
| Como ela gosta de trabalhar | memória de longo prazo — vale em todo projeto, não só neste |

A pergunta que resolve quase todos os casos: **isso muda o que eu faço já na primeira
resposta da sessão?** Se a resposta é "não, mas é bom saber quando o assunto aparecer",
é arquivo à parte, não `CLAUDE.md`.

## Espelho pra outras ferramentas

Antigravity e Gemini CLI não leem `CLAUDE.md` — leem `AGENTS.md`. Quando o projeto for
tocado por elas também, mantenha um `AGENTS.md` de até 25 linhas **gerado a partir do
`CLAUDE.md`**: frase de negócio, como rodar, o que não se reabre, armadilhas e um ponteiro
pro `.claude/checkpoint.md`. Espelho não é segunda fonte: divergiu, vale o `CLAUDE.md`.
Quem regrava é o `/checkpoint`.

## Auditar um que já existe

1. Meça (`wc -l`) e diga o custo antes de propor qualquer coisa.
2. Classifique **cada seção** nas duas tabelas acima.
3. O que sai não se apaga: **vira arquivo ao lado**, e o `CLAUDE.md` ganha um ponteiro.
4. Mostre o antes/depois em linhas e **espere aprovação** — `CLAUDE.md` é território dela.
