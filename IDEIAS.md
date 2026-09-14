# Ideias sobre o mona-dev

Capturadas por `ideia: plugin: <texto>` de qualquer projeto, sem custo de token.
Triagem com `/ideias plugin`.


---

## 14/09/2026 · Post no LinkedIn sobre o plugin

Pedido dela, pra fazer **depois** — não escrever antes de ela pedir.

Material bruto, nas palavras dela (é isso que dá o tom natural, não a lista de features):

> "estou gostando de desenvolver com ele, porque a IA não se perde"
> "a parte dos prompts é sensacional, porque fica tudo bem amarradinho"

Ganchos concretos já disponíveis, todos verificáveis:

- O problema de verdade: toda sessão nova renascia sem memória e relia repositório
  até reconstruir o que já sabia ontem. `/compact` salva a conversa e perde o durável;
  `/clear` não salva nada.
- Escada `spec → plano → tasks → task`, um degrau por sessão, e o `/prompt` montando
  o texto de entrada de cada degrau com arquivos nomeados e critério de pronto.
- **A melhor história é do dia 14/09:** ela perguntou "funciona certinho?", o teste
  contra o `tasks.md` real mostrou que `próxima` pegaria a T010 ⛓ — bloqueada por
  outra fatia — e geraria um prompt caprichado pra trabalho que não pode começar.
  Perguntar se funciona valeu mais que confiar que funcionava.
- Medição honesta de custo: o `/checkpoint` custava 3,9k tokens e foi para ~2,5k
  depois de cortar injeção; o gasto maior não estava onde parecia.

Decidir na hora: publicar o repo (é bom candidato a público e a pinned — ferramenta
de trabalho real, zero dado de cliente) ou postar sem link.
