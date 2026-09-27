---
description: Gerar o prompt pronto pra colar numa sessão limpa (spec, plano, tasks, task, tela, endpoint, bug, revisão, desenho)
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(ls:*), Bash(find:*), Bash(cat:*), Read, Grep, Glob, Agent
argument-hint: "<spec|plano|tasks|task|tela-nova|endpoint|bug|revisao|desenho> <o que é / 004 / T017 / passo 3b / próxima> [pro executor | pro antigravity | pro claude design | pro studio ia]"
---

## Projeto
!`basename "$PWD"` · !`git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "sem git"`

## Regras do projeto
!`head -60 CLAUDE.md 2>/dev/null || echo "(sem CLAUDE.md — sugira /projeto-novo)"`

---

Monte **o texto que ela vai colar numa sessão nova**, em bloco de código pra copiar.
O objetivo é que a sessão nova comece sabendo tudo e **não precise explorar o repositório**.

Todo prompt gerado tem estas cinco partes, sempre — **exceto `desenho`, que tem forma
própria** (ver a seção dele, mais abaixo: não vai pra uma sessão de código, vai pra uma
ferramenta de design):

1. **O que fazer** — uma frase, no imperativo.
2. **Arquivos a ler, nomeados** — poucos e específicos (`caminho:linha` quando couber).
   Nunca "explore o projeto". Se você não sabe quais são, descubra **agora**, aqui, que é
   a sessão que já tem contexto — esse é o serviço deste comando.
3. **O padrão a seguir** — o arquivo existente que serve de molde. Feature nova que copia
   um vizinho sai barata; feature nova inventada do zero sai cara e destoa.
4. **Critério de pronto** — como saber que acabou, verificável (o teste que passa, a tela
   que abre em 360px, o comando que roda limpo).
5. **Fora de escopo** — o que a sessão nova *não* deve tocar.

### Convenções que a base já tem, e o desenho/spec nunca repete

Antes de fechar o prompt, **procure isto na base agora** — não deixe pra sessão nova
descobrir sozinha, porque ela vai chutar, e o chute compila. Duas categorias já morderam:

- **Contrato de dados, não só de layout.** Desenho (Claude Design ou outro) é maquete
  visual — ele inventa um identificador plausível (`FORMATURA_FACULDADE`) onde o
  back-end de verdade tem outro (`FORMATURA_DE_FACULDADE`). Todo enum, status ou campo
  que a tela nova filtra, exibe ou envia de volta: confira o valor exato no
  schema/migration/DTO real, não o que "parece certo" pelo rótulo em português do
  desenho. TypeScript não acusa esse erro (as duas pontas são só `string`) — só quebra
  em runtime, e só se alguém clicar o filtro certo pra notar. Cite no prompt o
  arquivo:linha de onde o valor real vem.
- **Lista sempre paginada, se a base tem o padrão.** Procure um helper de paginação já
  usado em outras listagens (`grep` por paginação/página/limit nos services e
  controllers). Se existir, **é o default** para toda listagem nova — endpoint e tela —
  e só fica de fora com justificativa escrita no prompt (ex.: "N itens no domínio,
  cresce devagar, decisão X"). Lista sem fim que "funciona hoje" é a mesma falha
  que gerou o helper em primeiro lugar; sessão nova sem esse aviso reinventa o
  problema, não o helper.
- **O desenho é sempre desktop.** Se o critério de pronto pede um breakpoint estreito
  (360px é comum) e a base já tem um padrão de tabela responsiva (ex.: CSS module com
  `@media` que empilha linha em cartão), **nomeie esse arquivo-molde também** — copiar
  só o HTML do desenho (que não tem media query nenhuma) produz uma tela bonita no
  desktop e ilegível no celular, e "conferido em 360px" vira caixa marcada sem
  verificação de verdade.

### Fidelidade ao desenho é regra, não sugestão

Vale para `tela-nova` e para `task`/`passo` que implementa uma tela com desenho aprovado.
"Parecido com o desenho" é o resultado de sempre pular esta seção — force o oposto:

- **Cite o arquivo do desenho no prompt, não descreva de memória.** A sessão nova só bate
  igual se ela abrir o mesmo arquivo que você olhou — nomeie o caminho exato (o `.dc.html`,
  a pasta em `design/referencias-externas/`, o screenshot).
- **Texto é cópia, não paráfrase.** Rótulo de botão, mensagem de estado vazio, texto de
  erro: o prompt exige copiar a string literal do desenho, plural/singular incluído — não
  "algo como 'nenhum item encontrado'".
- **Cor, espaçamento e ordem vêm do desenho, não de "parece bom".** Se o desenho usa um
  token do design system do projeto (`--risco`, `--aviso`, etc.), o prompt nomeia o token —
  não deixa a sessão escolher a cor mais próxima que achar.
- **Liste todo estado/variante que o desenho mostra**, não só o que o pedido original citou
  — desenho geralmente cobre vazio/erro/parcial/somente-leitura; se a sessão nova só vir o
  estado principal, ela implementa só esse e os outros ficam "quase certos" por chute.
- **Proíba invenção explicitamente**: nada de elemento a mais que pareça fazer sentido
  (um botão, um campo, um link) que o desenho não tem, e nada a menos. Fora de escopo já
  cobre isso implicitamente — aqui é pra dizer com todas as letras.
- **O critério de pronto inclui bater com o desenho**, não só "funciona": comparação visual
  lado a lado (screenshot da implementação vs. o arquivo/imagem do desenho) antes de marcar
  pronto — mesma grade, cores, textos, estados. Sem essa comparação, "implementei a tela" e
  "implementei igual ao desenho" são coisas diferentes e só a segunda é o pedido.

E **cole junto o bloco de execução abaixo, sempre, literalmente** — ele custa 4 linhas no
prompt e corta ida e volta na sessão inteira:

```markdown
## Como executar
- Agrupe num mesmo turno as chamadas que não dependem uma da outra, e prefira um comando
  composto a três `Bash` seguidos. Cada turno relê o contexto inteiro — turno a mais é
  contexto relido a mais.
- Corte a saída: `| head`, `--short`, `--oneline`, `-n 20`. O que entra é relido pra sempre.
- Navegador: `read_page`/`get_page_text` pra conferir texto; screenshot (~3k tokens, fica no
  contexto) só pra o que é visual mesmo — alinhamento, cor, layout quebrado.
- Ao passar de ~120k de contexto, pare e grave o estado em vez de seguir arrastando a sessão.
```

E feche com **o modelo sugerido**, com o motivo em meia linha:

- **Sonnet** quando as cinco partes acima ficaram concretas — arquivo nomeado, molde
  existente, critério verificável. É o caso da maioria das telas e endpoints.
- **Opus** quando sobrou ambiguidade de verdade: decisão de arquitetura, spec,
  trade-off, ou bug cuja causa ninguém sabe.
- **Haiku** para mecânico e repetitivo: renomear, mover, aplicar o mesmo ajuste em N arquivos.

### `pro executor` — mandar direto pro agente, sem colar

Quando o pedido terminar com **"pro executor"**, o prompt não vira bloco pra copiar: vai
direto pro agente `executor` (Sonnet) do plugin, nesta mesma sessão. Serve pra task pequena
com a sessão ainda leve. Antes de despachar, três portões — se algum falhar, **não
despache**: diga o motivo em uma linha e entregue o prompt colável normal.

1. **Tipo:** só `task` (uma task, não `passo` inteiro), `tela-nova` e `endpoint`. `spec`,
   `plano`, `tasks`, `revisao` e `desenho` são decisão ou não são código; `bug` quase sempre
   tem "descubra" dentro — só vai se a causa já estiver apontada com `arquivo:linha`.
2. **Modelo:** se a régua acima daria **Opus** ou **Haiku**, não é pro `executor`. Ele é
   Sonnet, e só serve pra quando as cinco partes ficaram concretas.
3. **Tamanho:** o relatório volta pra esta sessão e é relido em toda resposta seguinte.
   Sessão já acima de ~80k, ou task que mexe em mais de ~5 arquivos: sessão limpa sai
   mais barato.

Passou nos três:

- Monte o prompt igual (cinco partes, convenções, fidelidade ao desenho, bloco "Como
  executar"), **sem a linha de modelo sugerido** — o agente já é Sonnet.
- **Não mostre o prompt no chat** — ele já vai inteiro pro agente; mostrar é pagar duas vezes.
  Uma linha só: *"Mandando T017 pro executor: <o que fazer>."*
- Chame o `executor` com o prompt como tarefa.
- Na volta, **confira antes de relatar**: `git diff --stat` bate com os arquivos que ele
  disse ter mexido? O critério de pronto rodou e passou? Se for `task`, o ✅ foi marcado no
  `tasks.md`? Divergência vai em destaque — relatório bonito não é prova.
- Relate em até 5 linhas: o que mudou, o critério, pendências. Sem commit.

Se o `executor` voltar com uma pergunta em vez de código, a task não estava pronta: responda
se você souber pelo contexto desta sessão e mande de novo; se não, leve a pergunta pra ela.

### Se o destino não for o Claude Code

Quando o pedido terminar com **"pro antigravity"** (ou citar outra ferramenta: Gemini CLI,
Cursor, Copilot), o prompt é o mesmo — as cinco partes não mudam. Mudam quatro coisas:

- **Nada de comando do Claude Code dentro do prompt.** `/checkpoint`, `/clear`, `/ideias`
  não existem lá. Colar um prompt que manda rodar um comando inexistente queima uma volta.
- **Modelo: traduza a régua, não o nome.** Em vez de "use Sonnet", diga "tarefa concreta,
  pode ir no modelo rápido" ou "tem decisão de arquitetura aqui, use o mais capaz" — ela
  escolhe no seletor da IDE.
- **Aponte o `AGENTS.md`**, não o `CLAUDE.md` — é o que aquelas ferramentas leem. Se o
  projeto não tiver `AGENTS.md`, avise **antes de gerar**: um `/checkpoint` aqui cria.
- **Feche pedindo o retorno.** O trabalho feito lá não volta sozinho pro checkpoint daqui.
  A última linha do prompt deve pedir, ao terminar: *o que mudou (arquivo → o quê), o que
  foi decidido e o próximo passo*, em até 5 linhas — é isso que ela cola aqui no
  `/checkpoint` pra retomada continuar valendo.
- **Redundância proposital nas restrições, não só uma menção.** Ferramenta fora do Claude
  Code não tem o hábito de "fidelidade ao desenho" nem o mesmo freio contra inventar código
  — ela explora mais e questiona menos. Repita as proibições em dois lugares: uma vez no
  corpo (onde a regra se aplica) e de novo numa lista curta no fim do prompt, tipo "Antes de
  marcar pronto, confira um a um: [lista]". Pra `tela-nova`/`task` com desenho, essa lista
  final tem que incluir, sempre: nenhum elemento a mais que o desenho não tem, nenhum campo/
  enum inventado (valor exato vem do arquivo:linha citado, não do rótulo em português), texto
  copiado literal (não parafraseado), e a comparação lado a lado com o desenho antes de
  marcar pronto. Custa quatro linhas a mais no prompt; sai mais barato que reabrir a task
  porque "quase" bateu.

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

- **`task`** — projeto com SDD (`specs/NNN-nome/tasks.md`). O argumento é o ID (`T017`),
  `passo 3b` (o Passo inteiro, que costuma ser o tamanho certo de uma sessão), ou
  `próxima`.

  **Antes de escolher, leia a legenda do topo do `tasks.md`.** Task sem ✅ não quer dizer
  task disponível: há marcas de bloqueio (no `acerto`, 🔒 = falta uma resposta, ⛓ = depende
  de outra fatia). **`próxima` é a primeira sem ✅ e sem marca de bloqueio** — pular isso
  gera um prompt bonito pra um trabalho que não pode começar. Se todas as que sobraram
  estiverem bloqueadas, **não gere prompt nenhum**: diga quem bloqueia cada uma e sugira
  a próxima fatia com task livre.

  Leia **só o necessário**: a task e as vizinhas do mesmo `## Passo`, a seção do `plan.md`
  que ela cita, e as duas seções do fim do `tasks.md` (*Regra que vale para toda tela desta
  fatia* e *Portões de aceitação*) — elas valem pra toda task e a sessão nova não vai
  adivinhar que existem.
  O **molde é a task irmã já marcada ✅**: nomeie os arquivos que ela produziu, é o padrão
  a copiar. O **critério de pronto** é o *Pronto quando* da própria task, mais os portões da
  fatia e os comandos que o `CLAUDE.md` manda rodar. Feche lembrando de **marcar ✅ no
  `tasks.md`** — é o passo que mais escapa, e sem ele a próxima sessão não sabe onde parou.
  Num `passo`, isso vale pra cada task do passo, uma a uma.

### Código direto, sem spec no meio

- **`tela-nova`** — nomeie o componente-molde já existente, a rota, o estado de carregando
  e de erro, e a conferência em 360px e nos dois temas. Se o projeto tem desenho, cite o
  arquivo do desenho **e** rode a checagem de "Convenções que a base já tem" acima —
  contrato de dados real e molde de responsividade, não só o HTML do desenho — **e** aplique
  "Fidelidade ao desenho é regra, não sugestão" abaixo, sempre que houver desenho.
- **`endpoint`** — contrato (entrada, saída, erro), onde a validação mora, o que vai pro
  log e o que **nunca** vai (dado pessoal), e o teste que prova. Se devolve lista,
  a checagem de paginação acima também vale aqui.
- **`bug`** — o sintoma observado, o que já foi descartado, os arquivos suspeitos e
  **como reproduzir**. Sem reprodução, o prompt é "adivinhe" e vai custar caro.
- **`revisao`** — o que revisar, contra qual régua, e o formato da devolutiva.

### `desenho` — pedir pra uma ferramenta de design desenhar uma tela

Diferente de todos os outros: não vai pra uma sessão de código, vai pra um chat de design
(Claude Design, Google AI Studio, v0, Figma Make…). Ninguém aqui vai *implementar* nada —
o resultado é maquete ou protótipo, pra depois virar prompt `tela-nova` ou `task`.

**Antes de escrever, confira se a tela já existe** — mesma regra do `tela-nova`: procure no
que o projeto já tem de design aprovado (pasta de design, canvas do Claude Design, backlog
de telas pendentes) antes de dizer que não existe. Gerar um briefing pra uma tela que já foi
desenhada é a mesma perda que reimplementar uma tela que já existe.

**Descubra o destino** (o pedido geralmente diz — "pro Claude Design", "pro Studio",
"pro v0" — se não disser, pergunte):

- **Ferramenta própria do projeto** (ex.: Claude Design, quando o projeto já usa um canvas
  próprio pra telas aprovadas): o resultado entra direto no artboard do projeto — siga as
  convenções que a base já tem (nome de variante, como o projeto já marca estado/tema,
  tokens do design system existente).
- **Ferramenta externa de prototipagem** (Google AI Studio, v0, Figma Make…): ela não
  conhece a stack do projeto e **vai inventar uma se você não disser o contrário** — deixe
  explícito **qual framework não criar** (ex.: "não crie projeto Next.js" se o projeto real
  for Next.js — é o erro mais comum dessas ferramentas) e deixe claro que é **protótipo de
  referência**, não código pra colar direto no repositório. Se o projeto tem arquivos de
  design system e telas já aprovadas, diga pra anexá-los na mesma conversa — é como a
  ferramenta copia tokens e vocabulário em vez de inventar os dela.

**A forma do prompt** (não são as cinco partes de código — são estas quatro):

1. **O que não se reabre** — a cor/token único do design system, o vocabulário do domínio
   (se o projeto tiver uma regra tipo "quem lê não é da área", ela vale aqui também), a
   regra de nunca usar dado real, os breakpoints e temas exigidos, e **o padrão a copiar**
   — a tela mais próxima já aprovada, nomeada (não "algo parecido com", o arquivo/label
   exato).
2. **A tela: `<nome>`** — quando ela aparece no fluxo, e o **dado real** que ela consome:
   nomeie o service/endpoint/tipo de verdade e os campos exatos — mesma checagem de
   "contrato de dados, não só de layout" que o `tela-nova` já faz. Maquete que inventa um
   campo plausível vira retrabalho quando a tela de verdade for implementada.
3. **Estados/variantes que precisam aparecer** — sucesso, vazio, parcial, erro — cada um
   com a condição real que o produz (não "e também um estado de erro", e sim "quando o
   campo X vem null").
4. **O que NÃO desenhar aqui** — cerca de escopo explícita. Ferramenta de design tende a
   "resolver" o que não foi pedido (um fluxo vizinho, uma tela de detalhe) só porque parecia
   fazer sentido — e cada coisa a mais desenhada é uma coisa a mais pra conferir contra o
   dado real depois.

Sem modelo sugerido no fim (ferramenta de design não tem esse seletor) — em vez disso,
feche lembrando: **quando o desenho voltar, registre onde o projeto guarda referência de
design** (se ele tiver essa convenção) antes de virar prompt de implementação — desenho que
não é registrado em lugar nenhum se perde depois de duas sessões, e a próxima pessoa reabre
a pergunta "isso já foi desenhado?" do zero.

Se faltar informação pra preencher alguma das cinco partes (quatro no caso do `desenho`),
**pergunte agora** — prompt com buraco é retrabalho garantido na sessão seguinte, e aí a
economia vira prejuízo.
