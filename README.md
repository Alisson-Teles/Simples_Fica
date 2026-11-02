# SIMPLES FICA

**O que fica perto, fica fácil.**

O **Simples Fica** é um aplicativo mobile em desenvolvimento para aproximar pessoas de estabelecimentos comerciais e prestadores de serviços da sua região. O objetivo é facilitar a descoberta de negócios, a consulta de produtos e serviços e o contato com quem os oferece.

> **Estado atual:** protótipo de interfaces em **Flutter/Dart**, com dados demonstrativos e gerenciamento de estado em memória. **Ainda não há backend, API, SQL Server ou autenticação real integrados.**

## Tecnologias

- **Flutter e Dart** — desenvolvimento das interfaces mobile.
- **Material Design 3** — componentes e tema visual.
- **ChangeNotifier + InheritedNotifier** — estado compartilhado de favoritos, perfil, negócios, catálogo e vendas durante a sessão, sem dependências extras.
- **Flutter Test** — testes locais.
- **Android Studio** — ambiente de desenvolvimento utilizado nesta fase.

## Funcionalidades implementadas em código

- **Splash:** apresentação inicial e navegação automática para a Home.
- **Home:** destaques patrocinados separados dos resultados orgânicos e cartões de estabelecimentos.
- **Explorar:** pesquisa, categoria, cidade, avaliação, situação de funcionamento, ordenação e filtro por tipo de estabelecimento.
- **Detalhes do estabelecimento:** dados públicos, catálogo, endereço, horários e avaliações demonstrativas.
- **Classificação automática:** comerciante, prestador de serviços ou ambos, com base nas **ofertas ativas** cadastradas.
- **Favoritos:** inclusão e remoção com estado compartilhado entre as telas durante a sessão.
- **Perfil:** exibição e edição de nome, e-mail e telefone com validações locais.
- **Navegação inferior:** Início, Explorar, Favoritos e Perfil.
- **Autenticação demonstrativa (Etapa 4):** telas de login, cadastro, escolha de tipo de conta e recuperação de senha com validações locais, **sem autenticar ou criar contas**.
- **Entrada no fluxo:** Perfil → Entrar ou criar conta → Login → Cadastro/Recuperação; as quatro abas públicas continuam acessíveis sem login.
- **Área do Comerciante (Etapa 5):** cadastro/edição de negócios, painel, catálogo de produtos e serviços, gestão de ofertas ativas e histórico de vendas em memória.
- **Vendas demonstrativas:** validação de quantidade, preço e estoque; redução de estoque dos produtos e cálculo local de receita.
- **Prévia, planos e anúncios:** visualização local do negócio, seleção visual de assinatura e prévia publicitária, sem publicação ou contratação.

As telas e ações de demonstração **não representam operações reais de pagamento, avaliação publicada, envio de mensagens ou gravação em servidor**.

## Estrutura de diretórios

A estrutura abaixo representa o projeto **após a implementação local da Etapa 5**, prevista para publicação no commit correspondente. A presença do código na branch `main` deve ser confirmada após o `git push`:

```text
Simples_Fica/
├── android/                         # Configurações do aplicativo Android
├── ios/                             # Projeto nativo iOS
├── linux/                           # Suporte à compilação para Linux
├── macos/                           # Suporte à compilação para macOS
├── web/                             # Suporte à compilação web
├── windows/                         # Suporte à compilação para Windows
│
├── lib/                             # Código-fonte Flutter/Dart
│   ├── main.dart                    # Inicialização e injeção do AppSession
│   │
│   ├── data/                        # Dados fictícios (substituíveis pela API)
│   │   ├── estabelecimentos_mock.dart
│   │   └── detalhes_mock.dart
│   │
│   ├── models/                      # Modelos e regras relacionadas aos dados
│   │   ├── estabelecimento.dart
│   │   ├── oferta.dart                   # Preços, estoque, SKU, ativo/destaque
│   │   ├── detalhes_estabelecimento.dart # Classificação de ofertas
│   │   ├── negocio_demo.dart            # Negócio e venda de teste
│   │   ├── usuario_perfil.dart
│   │   └── tipo_conta.dart              # Cliente ou comerciante no fluxo de cadastro
│   │
│   ├── state/                       # Estado compartilhado durante a sessão
│   │   ├── app_session.dart         # Favoritos, perfil, negócios, ofertas e vendas locais
│   │   └── app_scope.dart           # Disponibiliza o estado para as views
│   │
│   ├── utils/
│   │   └── formatacao.dart          # Moeda e data no protótipo
│   │
│   ├── theme/
│   │   └── app_theme.dart          # Paleta de cores e tema Material
│   │
│   ├── views/                       # Telas do aplicativo
│   │   ├── core/
│   │   │   ├── splash_view.dart
│   │   │   └── main_navigation_view.dart
│   │   ├── public/
│   │   │   ├── home_view.dart
│   │   │   ├── explore_view.dart
│   │   │   └── business_detail_view.dart
│   │   ├── account/
│   │   │   ├── favorites_view.dart
│   │   │   ├── profile_view.dart         # Acesso às novas views de autenticação
│   │   │   └── edit_profile_view.dart
│   │   ├── auth/                        # Interfaces de login e cadastro (Etapa 4)
│   │   │   ├── login_view.dart
│   │   │   ├── account_type_view.dart
│   │   │   ├── register_view.dart
│   │   │   └── forgot_password_view.dart
│   │   └── merchant/                    # Área do Comerciante (Etapa 5)
│   │       ├── merchant_dashboard_view.dart
│   │       ├── business_registration_view.dart
│   │       ├── edit_business_view.dart
│   │       ├── business_preview_view.dart
│   │       ├── offerings_view.dart
│   │       ├── offering_form_view.dart
│   │       ├── sales_view.dart
│   │       ├── subscription_view.dart
│   │       └── advertising_view.dart
│   │
│   └── widgets/                     # Componentes reutilizáveis
│       └── business/
│           └── estabelecimento_card.dart
│
├── test/
│   ├── widget_test.dart            # Testes do AppSession
│   └── merchant_state_test.dart     # Testes da Etapa 5
├── docs/                          # Registros técnicos de entregas
│   └── SIMPLES_FICA_Commit_Etapa_5.md
├── pubspec.yaml                    # Dependências e configuração Flutter
├── pubspec.lock                    # Versões resolvidas das dependências
├── analysis_options.yaml          # Regras de análise do Dart
├── .metadata                      # Metadados do Flutter
├── .gitignore                     # Arquivos que não entram no Git
└── README.md                      # Este documento
```

### Responsabilidades dos diretórios

| Diretório | Responsabilidade |
| --- | --- |
| `lib/data/` | Dados demonstrativos temporários. |
| `lib/models/` | Estruturas e regras dos dados; serão adaptadas para receber respostas da API. |
| `lib/state/` | Favoritos, perfil, negócios, catálogos, vendas e prévias em memória. |
| `lib/utils/` | Formatação demonstrativa de moeda e data. |
| `lib/theme/` | Configuração visual reutilizada por todo o app. |
| `lib/views/core/` | Abertura do aplicativo e navegação principal. |
| `lib/views/public/` | Descoberta de negócios e detalhes públicos. |
| `lib/views/account/` | Favoritos e perfil demonstrativo; ponto de entrada do login. |
| `lib/views/auth/` | Formulários de autenticação, tipo de conta, cadastro e recuperação (somente interface). |
| `lib/views/merchant/` | Painel de negócios, cadastro/edição, ofertas, vendas e telas demonstrativas de assinatura e anúncios. |
| `lib/widgets/business/` | Componentes visuais reutilizáveis de estabelecimentos. |
| `test/` | Testes automatizados. |

## Regras de negócio principais

### Classificação automática dos estabelecimentos

A classificação pública é calculada a partir do **catálogo de ofertas ativas**:

| Ofertas ativas | Tipo apresentado |
| --- | --- |
| Somente produtos | Comerciante |
| Somente serviços | Prestador de serviços |
| Produtos e serviços | Produtos e serviços |
| Nenhuma | Sem ofertas |

- Regra central: `lib/models/detalhes_estabelecimento.dart`.
- Tipo de cada oferta: `lib/models/oferta.dart`.
- Aplicação nos filtros: `lib/views/public/explore_view.dart`.
- Exibição condicional de seções: `lib/views/public/business_detail_view.dart`.

### Favoritos e perfil

`AppSession` controla os IDs de estabelecimentos favoritos e os dados do perfil demonstrativo. `AppScope` disponibiliza a mesma instância para as views. As alterações são refletidas na sessão atual, **sem persistência após o encerramento do aplicativo**.

### Área do Comerciante: catálogo e vendas locais (Etapa 5)

- O painel é acessível em **Perfil → Meus negócios (demonstração)** sem login real e não concede nenhuma permissão de produção.
- `NegocioDemo` mantém as ofertas do estabelecimento; o estado compartilhado gerencia negócios, ofertas e vendas durante a sessão.
- A regra `classificarOfertas()` continua calculando a classificação a partir das **ofertas ativas**, independentemente do estoque.
- Um produto exige preço positivo e estoque não negativo no cadastro. Serviços podem não ter preço indicado.
- O registro de venda aceita ofertas ativas com preço positivo e quantidade maior que zero. Produtos precisam de estoque disponível; uma venda reduz esse estoque.
- `receitaDemo()` soma os registros de vendas locais. Não representa pagamento, recebimento ou faturamento real.
- A prévia pública e a publicidade não são publicadas na Home/Explorar; selecionar planos não contrata assinaturas.
- Excluir um negócio remove seus registros de vendas e prévias demonstrativas associados.

Exemplo: produto com estoque de 5 unidades e preço de R$ 15,00. Venda de 2 unidades → estoque de 3 unidades e total registrado de R$ 30,00. Uma tentativa de vender 4 unidades adicionais deve ser rejeitada.

```text
Perfil → Meus negócios (demonstração) → Painel do Comerciante
                                         ├── Cadastrar / editar negócio
                                         ├── Produtos e serviços
                                         ├── Vendas demonstrativas
                                         ├── Prévia pública local
                                         ├── Assinatura demonstrativa
                                         └── Prévia de anúncios
```

### Tipo de conta e tipo de atuação: conceitos diferentes

- `lib/models/tipo_conta.dart`: distingue **Cliente** e **Comerciante** durante a escolha do cadastro.
- `lib/models/detalhes_estabelecimento.dart`: calcula se um **estabelecimento** atua com produtos, serviços ou ambos, de acordo com ofertas ativas.
- O tipo de conta **não** concede permissões reais nesta fase. No futuro, regras administrativas deverão ser autorizadas pelo backend.

### Login e cadastro demonstrativos (Etapa 4)

As interfaces de autenticação incluem validações locais de formato de e-mail, nome, telefone, senha e confirmação de senha. O login apresenta estado de carregamento simulado; a recuperação de senha somente valida o formato do e-mail. Todos os fluxos sinalizam que **nenhum login, cadastro ou e-mail foi realizado**.

```text
Perfil → Entrar ou criar conta → Login
                                 ├── Criar conta → Tipo de conta → Cadastro
                                 └── Esqueci a senha → Recuperação de senha
```

**Não utilize senhas reais nos testes.** O app não possui usuários cadastrados ou autenticação real. A Splash continua abrindo as quatro abas públicas; a tela de login é acessada pelo Perfil. O acesso demonstrativo por tipo de usuário e a abertura automática do login após a Splash são ideias para uma implementação posterior, **não estão prontas**.

## Como executar

### Pré-requisitos

- Flutter SDK compatível com `pubspec.yaml`.
- Android Studio ou VS Code com suporte a Flutter/Dart.
- Emulador Android configurado ou celular conectado para execução mobile.

### Passos

```bash
git clone https://github.com/Alisson-Teles/Simples_Fica.git
cd Simples_Fica
flutter pub get
flutter run
```

### Verificações

```bash
flutter analyze
flutter test
flutter test test/merchant_state_test.dart
```

> O repositório ainda utiliza o nome interno `git` no campo `name` do `pubspec.yaml`. Esse identificador poderá ser renomeado em uma etapa específica, com atualização das referências afetadas.

## Planejamento de desenvolvimento

| Etapa | Escopo | Situação |
| --- | --- | --- |
| 0–1 | Tema, Splash, Home, Explorar e navegação inicial | Implementado |
| 2 | Detalhes, catálogo e classificação automática | Concluído |
| 3 | Favoritos, Perfil e navegação com quatro abas | Implementado em código |
| 4 | Login, cadastro, tipo de conta e recuperação de senha (apenas UI) | Implementado em código; não autenticado |
| 5 | Cadastro, painel, catálogo, vendas, prévias, assinatura e anúncios (modo demo) | Implementado localmente; testes e publicação a confirmar |
| 6 | Administração geral | Planejado |
| 7 | Ajuda, configurações e telas auxiliares | Planejado |
| 8 | Revisão de navegação, acessibilidade e testes | Planejado |

A conclusão de cada etapa deve ser registrada após validação no emulador e execução dos testes correspondentes.

## Preparação para a API futura

Os arquivos abaixo **são fontes temporárias de dados** e deverão deixar de ser utilizados quando os dados vierem de uma API:

- `lib/data/estabelecimentos_mock.dart` — estabelecimentos demonstrativos.
- `lib/data/detalhes_mock.dart` — ofertas, horários, endereços e avaliações demonstrativas.

Os modelos, views e widgets devem ser preservados e adaptados para consumir esses dados por meio de uma camada de serviços/repositórios. `lib/state/app_session.dart` também precisará de integração com autenticação e persistência de favoritos, perfil, negócios, ofertas e vendas. A camada de autenticação futura deverá integrar os formulários `lib/views/auth/` a serviços próprios, sem armazenar senhas ou segredos no aplicativo.

**Não conectar o aplicativo Flutter diretamente ao SQL Server.** A comunicação futura deverá passar por uma API com validação e autorização no servidor.

### Pontos de integração da Etapa 5

| Camada atual | Evolução futura |
| --- | --- |
| `lib/models/negocio_demo.dart` | Modelo persistente de negócios e vendas, com identificadores atribuídos pelo servidor. |
| `lib/state/app_session.dart` | Repositórios e serviços para CRUD de negócios, ofertas, vendas e sessão autenticada. |
| `lib/views/merchant/business_registration_view.dart` e `edit_business_view.dart` | Cadastro e edição autorizados pelo backend. |
| `lib/views/merchant/offering_form_view.dart` e `offerings_view.dart` | Catálogo persistente, validações server-side e tratamento de erros. |
| `lib/views/merchant/sales_view.dart` | Registro de vendas com atomicidade para reserva/baixa de estoque. |
| `lib/views/merchant/subscription_view.dart` e `advertising_view.dart` | Planos, contratação, cobrança, aprovação e estado real de anúncios. |

## Limitações atuais

- Dados de estabelecimentos, distâncias, avaliações e horários são fictícios.
- Favoritos e perfil são mantidos somente em memória.
- Não há autenticação ou autorização reais de usuários; os formulários de login/cadastro são demonstrativos.
- Não há consulta ao banco de dados ou integração com API.
- Negócios criados na área do comerciante permanecem locais; não entram no catálogo público.
- Vendas, receitas, assinaturas e anúncios são demonstrativos, sem processamento financeiro.
- Não há login de comerciante nem autorização real de acesso ao painel.
- Ações de WhatsApp, telefone, rota, avaliações e cadastro podem ser apenas demonstrativas.


## Repositório

[GitHub — Alisson-Teles/Simples_Fica](https://github.com/Alisson-Teles/Simples_Fica)
