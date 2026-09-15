---
name: economia-de-contexto
description: Réguas de economia de token e continuidade — quando sugerir /compact, /clear, sessão nova ou /checkpoint; qual modelo (Opus, Sonnet, Haiku, fast mode) cabe em cada tarefa; quando delegar e quando NÃO delegar pra subagente. Use quando a Monalisa perguntar sobre gasto de token, contexto, limite de uso ou qual modelo usar; quando a sessão estiver longa; quando uma tarefa for delegável; ou antes de começar um trabalho grande.
---

# Economia de contexto

O caro nunca é a resposta longa. É **redescobrir o que já se sabia** — releitura de
repositório, contexto reconstruído do zero, a mesma explicação pela terceira vez.

## A conta que domina todas as outras

O gasto de uma sessão **não** é a soma das respostas: é `nº de respostas × tamanho do
contexto`, e o contexto só cresce. Toda resposta relê tudo que veio antes. Um screenshot
tirado na resposta 100 de uma sessão de 700 é relido 600 vezes.

Medição real de 48h dela (set/2026, projeto `acerto`): 671M de tokens de contexto relido,
**43% deles com a sessão acima de 200k**. Cortar em 100k teria economizado 39%; cortar em
60k, 61%. Nenhuma outra régua desta skill chega perto disso.

Daí as duas regras duras:

1. **Corte por token absoluto, não por porcentagem da janela.** Numa janela de 1M, 200k de
   contexto pinta "20%" e parece folga — mas é o ponto em que cada resposta já custa cinco
   vezes o começo da sessão. A régua é **80k = `/checkpoint`, 120k = `/clear`**, em qualquer
   janela. (A statusline dela já pinta amarelo em 80k e vermelho em 120k por isso.)
2. **Janela grande não é economia — é a remoção do freio.** `opus[1m]` só se justifica pra
   uma tarefa que *precisa* de 1M de uma vez. Como padrão, ela só deixa a sessão crescer
   até onde o preço machuca, porque a compactação automática nunca dispara.

## Turno a mais é contexto relido a mais

A outra metade da conta é o **número de turnos**, e essa é responsabilidade de quem executa,
não dela. Na medição: **2.499 chamadas de ferramenta em 48h, nenhuma agrupada** — uma por
turno, cada turno relendo ~150k. Agrupar o que é independente valeria 10–15% do total.

- Chamadas que não dependem uma da outra vão **no mesmo turno**.
- Três `Bash` em sequência viram um comando composto.
- No navegador existe `browser_batch` — foi usado 43 vezes contra 162 chamadas soltas.

**Thinking também é contexto**: foi 46% de todo o output (1,39M tokens em 48h) e fica na
sessão sendo relido. Tarefa com as cinco partes concretas quase não precisa dele — outro
motivo pro `/prompt` pagar tão bem.

## Quando sugerir o quê

| Situação | Sugestão | Por quê |
|---|---|---|
| A tarefa acabou, vem outra do mesmo projeto | `/checkpoint` e depois `/clear` | a conversa não serve mais; o durável já está gravado |
| A tarefa continua, mas o contexto está pesado | `/checkpoint` e depois `/compact` | o fio da conversa ainda importa |
| Trocar de projeto | `/checkpoint` e **sessão nova** | contexto de outro projeto é só peso |
| Ela quer parar por hoje | `/checkpoint` | sem ele, amanhã se paga tudo de novo |

**`/checkpoint` vem antes dos três.** Compactar sem checkpoint perde o durável; limpar sem
checkpoint perde tudo.

Mas ele **não é de graça** (~3k tokens: injeta o estado, escreve o arquivo, reavalia memória).
Vale quando o contexto vai ser descartado logo em seguida. **Task fechada não é motivo** — se a
próxima task é do mesmo projeto e a sessão ainda está leve, seguir direto é mais barato que
gravar e recarregar.

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
- **Screenshot do navegador: ~3k tokens cada, e fica no contexto pra sempre.** Foi o
  retorno de ferramenta mais caro da medição (124k tokens em 42 chamadas numa sessão só).
  `read_page` e `get_page_text` respondem "o texto está certo?" por ~90 tokens. Screenshot
  só pra o que é genuinamente visual: alinhamento, cor, quebra de layout.
- **Saída de comando sem corte.** `| head`, `--short`, `--oneline`, `-n 20`. Um `git diff`
  cru ou um `npm test` verboso entra inteiro e é relido em toda resposta seguinte.

## Captura sem custo

Ideia no meio do trabalho: `ideia: <texto>` — o hook grava e apaga o prompt, então ela
nunca chega ao modelo. Zero token, zero desvio de assunto. Triagem depois, com `/ideias`.
