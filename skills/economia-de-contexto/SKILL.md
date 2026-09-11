---
name: economia-de-contexto
description: Réguas de economia de token e continuidade — quando sugerir /compact, /clear, sessão nova ou /checkpoint; qual modelo (Opus, Sonnet, Haiku, fast mode) cabe em cada tarefa; quando delegar e quando NÃO delegar pra subagente. Use quando a Monalisa perguntar sobre gasto de token, contexto, limite de uso ou qual modelo usar; quando a sessão estiver longa; quando uma tarefa for delegável; ou antes de começar um trabalho grande.
---

# Economia de contexto

O caro nunca é a resposta longa. É **redescobrir o que já se sabia** — releitura de
repositório, contexto reconstruído do zero, a mesma explicação pela terceira vez.

## Quando sugerir o quê

| Situação | Sugestão | Por quê |
|---|---|---|
| A tarefa acabou, vem outra do mesmo projeto | `/checkpoint` e depois `/clear` | a conversa não serve mais; o durável já está gravado |
| A tarefa continua, mas o contexto está pesado | `/checkpoint` e depois `/compact` | o fio da conversa ainda importa |
| Trocar de projeto | `/checkpoint` e **sessão nova** | contexto de outro projeto é só peso |
| Ela quer parar por hoje | `/checkpoint` | sem ele, amanhã se paga tudo de novo |

**`/checkpoint` vem antes dos três.** Compactar sem checkpoint perde o durável; limpar sem
checkpoint perde tudo.

Sugira **uma vez**, em uma linha, e siga trabalhando. Lembrete de economia repetido é o
próprio desperdício que ele diz combater.

## Qual modelo

| Modelo | Cabe quando | Exemplo real dela |
|---|---|---|
| **Opus** | ambiguidade real: arquitetura, spec, trade-off, revisão crítica, bug sem causa conhecida | revisar as specs do ERP contra a constitution |
| **Sonnet** | a tarefa está escrita: arquivo nomeado, molde existente, critério de pronto verificável | mais uma tela seguindo o padrão das outras |
| **Haiku** | mecânico e repetitivo | renomear em N arquivos, mover pasta |

O teste é um só: **`/prompt` conseguiu preencher as cinco partes com coisa concreta?** Se
sim, Sonnet faz. Se sobrou "descubra", é Opus — e delegar ambiguidade pro modelo barato
custa mais caro, porque volta errado.

**Fast mode continua sendo Opus**, com saída mais rápida — não é modelo menor. É a
economia de menor risco que existe; sugira antes de sugerir trocar de modelo.

## Subagente é caro, não barato

Cada subagente **nasce frio** e redescobre o que esta sessão já sabe. Vale quando a
varredura é larga e você só quer a conclusão (procurar em 200 arquivos). Não vale pra
tarefa que esta sessão já tem contexto pra fazer — aí é pagar duas vezes pelo mesmo saber.

## O que custa sem aparecer

- **`CLAUDE.md`**: cada linha é paga em **toda** sessão daquele projeto. Teto de 60 linhas.
- **`~/.claude/rules/`**: pago em **todo** projeto, sempre. Quase tudo ali deveria ser skill.
- **Skill invocada**: fica no contexto até o fim da sessão, e a compactação devolve só os
  primeiros 5.000 tokens de cada. Skill gorda custa mais e ainda chega cortada.
- **Ler arquivo inteiro** quando bastava `sed -n '40,80p'`.

## Captura sem custo

Ideia no meio do trabalho: `ideia: <texto>` — o hook grava e apaga o prompt, então ela
nunca chega ao modelo. Zero token, zero desvio de assunto. Triagem depois, com `/ideias`.
