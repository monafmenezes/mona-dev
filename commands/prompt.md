---
description: Gerar o prompt pronto pra colar numa sessão limpa (task do tasks.md, tela, endpoint, bug, spec, revisão)
allowed-tools: Bash(git status:*), Bash(ls:*), Bash(find:*), Bash(cat:*), Read, Grep, Glob
argument-hint: "<task|tela-nova|endpoint|bug|spec|revisao> <o que é / T017 / próxima>"
---

## Projeto
!`basename "$PWD"` · !`git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "sem git"`

## Regras do projeto
!`head -60 CLAUDE.md 2>/dev/null || echo "(sem CLAUDE.md — sugira /projeto-novo)"`

---

Monte **o texto que ela vai colar numa sessão nova**, em bloco de código pra copiar.
O objetivo é que a sessão nova comece sabendo tudo e **não precise explorar o repositório**.

Todo prompt gerado tem estas cinco partes, sempre:

1. **O que fazer** — uma frase, no imperativo.
2. **Arquivos a ler, nomeados** — poucos e específicos (`caminho:linha` quando couber).
   Nunca "explore o projeto". Se você não sabe quais são, descubra **agora**, aqui, que é
   a sessão que já tem contexto — esse é o serviço deste comando.
3. **O padrão a seguir** — o arquivo existente que serve de molde. Feature nova que copia
   um vizinho sai barata; feature nova inventada do zero sai cara e destoa.
4. **Critério de pronto** — como saber que acabou, verificável (o teste que passa, a tela
   que abre em 360px, o comando que roda limpo).
5. **Fora de escopo** — o que a sessão nova *não* deve tocar.

E feche com **o modelo sugerido**, com o motivo em meia linha:

- **Sonnet** quando as cinco partes acima ficaram concretas — arquivo nomeado, molde
  existente, critério verificável. É o caso da maioria das telas e endpoints.
- **Opus** quando sobrou ambiguidade de verdade: decisão de arquitetura, spec,
  trade-off, ou bug cuja causa ninguém sabe.
- **Haiku** para mecânico e repetitivo: renomear, mover, aplicar o mesmo ajuste em N arquivos.

Por tipo:

- **`task`** — projeto com SDD (`specs/NNN-nome/tasks.md`). O argumento é o ID (`T017`) ou
  `próxima` (a primeira sem ✅). Leia **só o necessário**: a task e as vizinhas do mesmo
  `## Passo`, a seção do `plan.md` que ela cita, e as duas seções do fim do `tasks.md`
  (*Regra que vale para toda tela desta fatia* e *Portões de aceitação*) — elas valem pra
  toda task e a sessão nova não vai adivinhar que existem.
  O **molde é a task irmã já marcada ✅**: nomeie os arquivos que ela produziu, é o padrão
  a copiar. O **critério de pronto** são os portões da fatia mais os comandos que o
  `CLAUDE.md` manda rodar. Feche lembrando de **marcar ✅ no `tasks.md`** — é o passo que
  mais escapa, e sem ele a próxima sessão não sabe onde parou.

- **`tela-nova`** — nomeie o componente-molde já existente, a rota, o estado de carregando
  e de erro, e a conferência em 360px e nos dois temas. Se o projeto tem desenho, cite o
  arquivo do desenho.
- **`endpoint`** — contrato (entrada, saída, erro), onde a validação mora, o que vai pro
  log e o que **nunca** vai (dado pessoal), e o teste que prova.
- **`bug`** — o sintoma observado, o que já foi descartado, os arquivos suspeitos e
  **como reproduzir**. Sem reprodução, o prompt é "adivinhe" e vai custar caro.
- **`spec`** — o formato de spec do projeto e as cláusulas que a governam. Sem stack.
- **`revisao`** — o que revisar, contra qual régua, e o formato da devolutiva.

Se faltar informação pra preencher alguma das cinco partes, **pergunte agora** — prompt
com buraco é retrabalho garantido na sessão seguinte, e aí a economia vira prejuízo.
