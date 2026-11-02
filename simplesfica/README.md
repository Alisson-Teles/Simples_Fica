# Simples Fica — Flutter / Dart

**O que fica perto, fica fácil.**

Esta pasta contém o aplicativo mobile do Simples Fica. Consulte também o [README principal](../README.md). Este documento descreve o **estado-alvo da Etapa 6 consolidada**, incluindo a integração das regras administrativas com Home, Explorar e o painel do Comerciante. Os arquivos precisam estar no projeto local e passar em compilação/testes antes do commit.

> **Modo demo:** todos os dados são fictícios e mantidos em memória. A estrutura .NET em `../backsimplesfica/` ainda não está integrada. Não existem contas reais, permissões seguras ou operações financeiras reais.

## Inicialização

```bash
cd simplesfica  # caso esteja na raiz do repositório
flutter pub get
flutter analyze
flutter test
flutter run
```

Se já estiver dentro de `simplesfica/`, **não repita** o `cd simplesfica`. Para mudanças de modelos/enums/instâncias compartilhadas, encerre e inicie o app ou use Hot Restart.

## Contas fictícias

| Perfil | E-mail | Senha de demonstração |
|---|---|---|
| Cliente | `cliente@simplesfica.test` | `Cliente123!` |
| Comerciante | `comerciante@simplesfica.test` | `Comerciante123!` |
| Administrador | `admin@simplesfica.test` | `Admin123!` |
| Visitante | Acesso sem credenciais | — |

As credenciais estão no código (`lib/data/contas_demo.dart`) e não devem ser usadas para dados reais. Splash → Login → quatro abas públicas; a aba Perfil exibe o menu de Comerciante ou Administrador, dependendo da seleção fictícia.

## Organização (Etapa 6 consolidada)

```text
lib/
├── main.dart
├── data/
│   ├── contas_demo.dart
│   ├── estabelecimentos_mock.dart
│   └── detalhes_mock.dart
├── models/
│   ├── admin_demo_models.dart             # estados administrativos, publicação e atuação
│   ├── conta_demo.dart
│   ├── estabelecimento.dart
│   ├── detalhes_estabelecimento.dart      # classificarOfertas() / TipoAtuacao
│   ├── negocio_demo.dart
│   ├── oferta.dart
│   ├── tipo_conta.dart
│   └── usuario_perfil.dart
├── state/
│   ├── app_scope.dart                     # expõe AppSession aos widgets
│   ├── app_session.dart                   # sessão e catálogo público compartilhado
│   ├── admin_demo_state.dart             # situação, publicação, anúncios, auditoria
│   └── admin_business_metrics.dart       # métricas e filtros por tipo/suspensão
├── theme/app_theme.dart
├── utils/formatacao.dart
├── views/
│   ├── core/                             # Splash + quatro abas
│   ├── auth/                             # Login/cadastro/recuperação (demo)
│   ├── account/                          # Perfil e Favoritos
│   ├── public/                           # Home, Explorar, detalhes
│   ├── merchant/                         # CRUD, catálogo, vendas e prévias
│   └── admin/
│       ├── admin_demo_view.dart          # entrada ligada ao AppSession
│       ├── admin_dashboard_view.dart     # painéis interativos
│       ├── business_management_view.dart # suspensão e publicação
│       ├── users_management_view.dart    # contas e situações
│       ├── financial_overview_view.dart
│       ├── ads_management_view.dart
│       ├── audit_logs_view.dart
│       └── reports_view.dart
└── widgets/business/
    └── estabelecimento_card.dart

test/
├── widget_test.dart
├── demo_access_test.dart
├── merchant_state_test.dart
├── admin_demo_state_test.dart
├── admin_dashboard_metrics_test.dart
├── admin_business_metrics_test.dart
├── admin_suspension_metrics_test.dart
└── catalogo_integrado_test.dart

docs/
└── SIMPLES_FICA_Commit_Etapa_6.md
```

**Estrutura-alvo:** os arquivos da Etapa 6 não constavam integralmente da branch remota `main` na última consulta. Os arquivos `.dart` são os códigos fornecidos e aplicados durante a implementação local; esta documentação não os cria automaticamente.

## Arquitetura do estado

- `AppScope` é um `InheritedNotifier<AppSession>` que notifica as telas quando a sessão muda.
- `AppSession` contém uma instância compartilhada de `AdminDemoState`, via `sessao.administracao`. Ao receber uma notificação administrativa, informa as telas públicas com `notifyListeners()`.
- `AdminDemoView` consulta o perfil demonstrativo e passa `sessao.administracao` para `AdminDashboardView`; **não cria mais estado administrativo isolado**.
- O administrador altera a situação de negócios/usuários, aprova ou retira publicações, pausa anúncios e analisa denúncias na memória. As alterações geram logs demonstrativos.
- `AppSession` apresenta `estabelecimentosPublicos`, `estabelecimentoPorId`, `detalhesPorId` e `negocioDisponivelPublicamente`, usados por Home, Explorar, Favoritos e detalhes.
- Negócios cadastrados pelo Comerciante entram em `AdminDemoState` como **não publicados**; editar as ofertas sincroniza sua classificação, **sem limpar** suspensão ou decisão de publicação.

### Regra central de visibilidade

```dart
bool get visivelPublicamente =>
    publicado && status == StatusNegocioAdmin.ativo;
```

Somente negócios **ativos E publicados** aparecem na Home/Explorar. Os suspensos/inativos continuam visíveis ao Administrador. O estado `aberto` de um estabelecimento mock se refere ao funcionamento demonstrativo do local, não à aprovação administrativa.

As campanhas só aparecem ao público se o anúncio estiver ativo e seu negócio estiver visível; a Home lista patrocinados separadamente da seção orgânica, e a Explorar continua com busca e ordenação independentes de publicidade. A prévia do anúncio criada pelo Comerciante **não publica a campanha automaticamente**.

### Cadastro e publicação: teste entre perfis

1. Entre como Comerciante. A **Tech Cell — Demonstração** é criada como negócio local de teste, com ofertas e uma venda fictícia.
2. Entre como Administrador; o negócio local deve constar na listagem administrativa como **não publicado**.
3. Publique o negócio. A publicação somente é aceita se estiver **ativo e tiver oferta ativa**.
4. Troque para Cliente. O negócio aparece na Explorar, com detalhes e ofertas da sessão.
5. Volte ao Administrador e suspenda esse negócio. Ele some da Home/Explorar; se estiver favoritado no mesmo perfil/sessão, é tratado como indisponível no cartão de favoritos.
6. Editar catálogo do Comerciante não deve reativar ou republicar automaticamente negócio suspenso.

**Troca de perfil:** a implementação integrada preserva os negócios e estados administrativos **até reiniciar o processo**, para suportar o fluxo acima; os favoritos da conta demonstrativa são limpos na troca. Essa regra substitui a antiga descrição de limpeza integral ao sair.

## Painel do proprietário

| Grupo | Indicadores (cards clicáveis) | Destino |
|---|---|---|
| Pessoas | Clientes; ativos; inativos/não ativos; suspensos; contas de comerciante | Usuários, com filtros iniciais |
| Estabelecimentos | Total com atuação; somente comerciantes; somente prestadores; ambos; ativos; suspensos; suspensos por atuação; visíveis ao público, se adicionado | Estabelecimentos, com filtros |
| Operação | Inadimplência; receita fictícia aprovada; anúncios elegíveis; denúncias pendentes | Financeiro, Publicidade e Denúncias |

A classificação comercial usa **ofertas ativas**: somente produtos = Comerciante; somente serviços = Prestador; produtos e serviços = Ambos; nenhuma oferta ativa = Sem ofertas. A categoria Ambos não duplica as duas exclusivas.

**Suspensão de conta vs suspensão de estabelecimento** são assuntos diferentes. Um cliente `suspenso` integra o indicador de clientes não ativos; bloquear uma conta no painel demo ainda **não revoga logins reais**. Uma suspensão do estabelecimento independe do tipo de atuação: um prestador suspenso continua contando como prestador no total de cadastros.

### Exemplo inicial (antes de entrar como Comerciante)

| Métrica | Valor demonstrativo |
|---|---:|
| Negócios registrados | 5 |
| Ativos e publicados (públicos) | 3 |
| Suspensos | 1 (Barbearia Moderna) |
| Inativos | 1 (Oficina Rápida) |
| Somente comerciantes | 2 |
| Somente prestadores | 2 |
| Ambos | 1 (Tech Cell) |
| Clientes / ativos / inativos | 2 / 1 / 1 |
| Clientes suspensos | 0 |

**Os números mudam** ao entrar como Comerciante (novo negócio de demonstração ainda não publicado), cadastrar produtos ou simular suspensão/publicação. Logo, não devem ser usados como constantes nas views.

## Telas da Etapa 6

- `admin_dashboard_view.dart`: métricas derivadas e atalhos, atualização por `AnimatedBuilder`, gráfico sintético de 14 dias.
- `business_management_view.dart`: busca e filtros de atuação/situação, detalhes do estado de publicação, ações simuladas de suspensão e publicação confirmadas por diálogo.
- `users_management_view.dart`: busca por nome/e-mail, situação `ativo`, `inativo`, `suspenso`, `bloqueado`, e filtro por papel; mudanças documentadas no log.
- `financial_overview_view.dart`: pagamentos fictícios aprovados, pendentes e vencidos, sem ação financeira real.
- `ads_management_view.dart`: campanha ativa/pausada e indicação de elegibilidade pública (depende também do negócio).
- `audit_logs_view.dart`: eventos locais com identificação descritiva e horário da máquina, sem persistência.
- `reports_view.dart`: denúncias de teste com classificação pendente/analisada/arquivada.

## Testes

Na pasta `simplesfica/`:

```bash
flutter analyze
flutter test
```

Rodar individualmente caso alguma regressão seja encontrada:

```bash
flutter test test/admin_demo_state_test.dart
flutter test test/admin_dashboard_metrics_test.dart
flutter test test/admin_business_metrics_test.dart
flutter test test/admin_suspension_metrics_test.dart
flutter test test/catalogo_integrado_test.dart
flutter test test/demo_access_test.dart
flutter test test/merchant_state_test.dart
```

Verificações manuais importantes:

- Suspender `Tech Cell` e conferir sua ausência na Explorar.
- Suspender `Café da Praça` e conferir ausência da publicidade, mantendo o anúncio no cadastro administrativo.
- Reativar e conferir retorno se a publicação estiver ativa.
- Entrar como Comerciante, consultar o novo cadastro como Administrador, publicar e conferir como Cliente.
- Favoritos previamente salvos não devem abrir ações comerciais para negócios indisponíveis.
- Filtro Suspensos deve continuar disponível; Ambos deve permanecer categoria exclusiva.
- O teste antigo de logout deve ser **interpretado pela nova regra**: visitante não vê negócios comerciais pelo getter, mas cadastros/estados continuam no estado compartilhado até o reinício. Atualizar qualquer teste local que ainda exija o apagamento efetivo do catálogo administrativo no logout.

**Correções recentes de compilação:** `users_management_view.dart` precisa tratar `StatusUsuarioAdmin.suspenso` no `switch`; `home_view.dart` não pode usar `const Text` quando interpola `${disponiveis.length}`. Revisar também a tipagem dos favoritos como `List<Estabelecimento>` (evitar `dynamic`). Nenhuma aprovação automática de `flutter analyze` ou `flutter test` é presumida.

## Limites de segurança / persistência

A edição de `AppSession` e a seleção de Admin são suficientes para testar navegação local, mas não são autorização segura. Um usuário malicioso poderia modificar um app Flutter; o backend deverá aplicar permissões, vínculos de propriedade, políticas de publicação, suspensão e elegibilidade de anúncios em **cada operação**. Não existem pagamentos, cobranças, moderação ou auditoria reais. O armazenamento local em memória não sobrevive a reinício nem sincroniza celulares.

**Integração futura:** Flutter → API .NET → SQL Server, com autenticação segura e persistência; não conectar o Flutter diretamente ao banco nem colocar senhas de produção no código.

Documentação do commit: [`docs/SIMPLES_FICA_Commit_Etapa_6.md`](docs/SIMPLES_FICA_Commit_Etapa_6.md).
