---
description: Gerar o prompt pronto pra colar numa sessão limpa (spec, plano, tasks, task, tela, endpoint, bug, revisão)
allowed-tools: Bash(git status:*), Bash(ls:*), Bash(find:*), Bash(cat:*), Read, Grep, Glob
argument-hint: "<spec|plano|tasks|task|tela-nova|endpoint|bug|revisao> <o que é / 004 / T017 / próxima>"
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

### Projeto com SDD — a fatia vai de `spec` a `task`, nessa ordem

Cada um desses tipos só é honesto se o anterior estiver fechado. Se o argumento pedir um
degrau e o de trás estiver com buraco, **diga isso antes de gerar** — é mais barato do que
um plano chutado ou uma task sem critério.

- **`spec`** — o formato de spec do projeto e as cláusulas que a governam. Sem stack.

- **`plano`** — a spec está fechada e falta decidir **como**. O argumento é o número da fatia
  (`004`). Leia a `spec.md` inteira (é o insumo, não dá pra resumir), a constitution, e **um
  `plan.md` já escrito** de outra fatia como molde de formato.
  Duas coisas separam um bom prompt de plano de um ruim:
  **(a) as perguntas abertas da spec** (a seção do fim) — liste cada uma no prompt, porque
  plano escrito sobre pergunta aberta chuta e o chute vira código; se houver alguma sem
  resposta, avise **aqui** que ela precisa decidir antes.
  **(b) é aqui que a stack entra** — a spec não cita tecnologia de propósito, então o prompt
  tem que dizer qual é a stack já fechada do projeto, senão a sessão nova reabre o que já
  foi decidido. O que o plano precisa entregar: modelo de dados, **ordem de construção**,
  onde reaproveitar em vez de repetir, fora de escopo e riscos.
  Modelo: **Opus** — é decisão, não transcrição. E o prompt fecha dizendo que o plano é
  pra ela **ler e aprovar**, não pra virar código na mesma sessão.

- **`tasks`** — o plano está aprovado e falta quebrar em passos. O argumento é o número da
  fatia (`004`). Leia a **ordem de construção** do `plan.md` (é a espinha do `tasks.md`), os
  critérios de aceitação da `spec.md` — que viram a seção *Portões de aceitação da fatia* —
  e **um `tasks.md` já escrito** como molde: numeração, o `✅`, o `[P]` do que roda em
  paralelo, os `## Passo N`.
  O que separa task boa de ruim é a task caber numa sessão só e ter critério próprio:
  o prompt deve exigir **arquivo nomeado** em cada task e proibir task do tipo "implementar
  a fatia". As duas seções do fim (*Regra que vale para toda tela desta fatia* e *Portões
  de aceitação*) não são enfeite — são elas que o `/prompt task` vai buscar depois, então
  o prompt tem que pedir as duas explicitamente.
  Modelo: **Sonnet** se o plano tem ordem de construção clara; **Opus** se a ordem ainda
  está no ar — aí o que falta é plano, não tasks.

- **`task`** — projeto com SDD (`specs/NNN-nome/tasks.md`). O argumento é o ID (`T017`) ou
  `próxima` (a primeira sem ✅). Leia **só o necessário**: a task e as vizinhas do mesmo
  `## Passo`, a seção do `plan.md` que ela cita, e as duas seções do fim do `tasks.md`
  (*Regra que vale para toda tela desta fatia* e *Portões de aceitação*) — elas valem pra
  toda task e a sessão nova não vai adivinhar que existem.
  O **molde é a task irmã já marcada ✅**: nomeie os arquivos que ela produziu, é o padrão
  a copiar. O **critério de pronto** são os portões da fatia mais os comandos que o
  `CLAUDE.md` manda rodar. Feche lembrando de **marcar ✅ no `tasks.md`** — é o passo que
  mais escapa, e sem ele a próxima sessão não sabe onde parou.

### Código direto, sem spec no meio

- **`tela-nova`** — nomeie o componente-molde já existente, a rota, o estado de carregando
  e de erro, e a conferência em 360px e nos dois temas. Se o projeto tem desenho, cite o
  arquivo do desenho.
- **`endpoint`** — contrato (entrada, saída, erro), onde a validação mora, o que vai pro
  log e o que **nunca** vai (dado pessoal), e o teste que prova.
- **`bug`** — o sintoma observado, o que já foi descartado, os arquivos suspeitos e
  **como reproduzir**. Sem reprodução, o prompt é "adivinhe" e vai custar caro.
- **`revisao`** — o que revisar, contra qual régua, e o formato da devolutiva.

Se faltar informação pra preencher alguma das cinco partes, **pergunte agora** — prompt
com buraco é retrabalho garantido na sessão seguinte, e aí a economia vira prejuízo.
