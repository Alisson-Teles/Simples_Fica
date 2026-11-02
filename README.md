# SIMPLES FICA

**O que fica perto, fica fácil.**

O **Simples Fica** é um aplicativo mobile em desenvolvimento para aproximar pessoas de estabelecimentos comerciais e prestadores de serviços da sua região. O objetivo é facilitar a descoberta de negócios, a consulta de produtos e serviços e o contato com quem os oferece.

> **Estado atual:** protótipo de interfaces em **Flutter/Dart**, com dados demonstrativos e gerenciamento de estado em memória. **Ainda não há backend, API, SQL Server ou autenticação real integrados.**

## Tecnologias

- **Flutter e Dart** — desenvolvimento das interfaces mobile.
- **Material Design 3** — componentes e tema visual.
- **ChangeNotifier + InheritedNotifier** — compartilhamento de favoritos e perfil durante a sessão, sem dependências extras.
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

As telas e ações de demonstração **não representam operações reais de pagamento, avaliação publicada, envio de mensagens ou gravação em servidor**.

## Estrutura de diretórios

A estrutura abaixo corresponde aos arquivos presentes no repositório na conclusão da Etapa 3:

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
│   │   ├── oferta.dart
│   │   ├── detalhes_estabelecimento.dart
│   │   └── usuario_perfil.dart
│   │
│   ├── state/                       # Estado compartilhado durante a sessão
│   │   ├── app_session.dart         # Favoritos e perfil em memória
│   │   └── app_scope.dart           # Disponibiliza o estado para as views
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
│   │   └── account/
│   │       ├── favorites_view.dart
│   │       ├── profile_view.dart
│   │       └── edit_profile_view.dart
│   │
│   └── widgets/                     # Componentes reutilizáveis
│       └── business/
│           └── estabelecimento_card.dart
│
├── test/
│   └── widget_test.dart            # Testes do AppSession
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
| `lib/state/` | Estado compartilhado de favoritos e perfil durante a sessão atual. |
| `lib/theme/` | Configuração visual reutilizada por todo o app. |
| `lib/views/core/` | Abertura do aplicativo e navegação principal. |
| `lib/views/public/` | Descoberta de negócios e detalhes públicos. |
| `lib/views/account/` | Favoritos e perfil demonstrativo. |
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
```

> O repositório ainda utiliza o nome interno `git` no campo `name` do `pubspec.yaml`. Esse identificador poderá ser renomeado em uma etapa específica, com atualização das referências afetadas.

## Planejamento de desenvolvimento

| Etapa | Escopo | Situação |
| --- | --- | --- |
| 0–1 | Tema, Splash, Home, Explorar e navegação inicial | Implementado |
| 2 | Detalhes, catálogo e classificação automática | Concluído |
| 3 | Favoritos, Perfil e navegação com quatro abas | Implementado em código |
| 4 | Interfaces de login, cadastro e recuperação de senha | Planejado |
| 5 | Cadastro e painel do comerciante | Planejado |
| 6 | Administração geral | Planejado |
| 7 | Ajuda, configurações e telas auxiliares | Planejado |
| 8 | Revisão de navegação, acessibilidade e testes | Planejado |

A conclusão de cada etapa deve ser registrada após validação no emulador e execução dos testes correspondentes.

## Preparação para a API futura

Os arquivos abaixo **são fontes temporárias de dados** e deverão deixar de ser utilizados quando os dados vierem de uma API:

- `lib/data/estabelecimentos_mock.dart` — estabelecimentos demonstrativos.
- `lib/data/detalhes_mock.dart` — ofertas, horários, endereços e avaliações demonstrativas.

Os modelos, views e widgets devem ser preservados e adaptados para consumir esses dados por meio de uma camada de serviços/repositórios. `lib/state/app_session.dart` também precisará de integração com autenticação e persistência de favoritos/perfil.

**Não conectar o aplicativo Flutter diretamente ao SQL Server.** A comunicação futura deverá passar por uma API com validação e autorização no servidor.

## Limitações atuais

- Dados de estabelecimentos, distâncias, avaliações e horários são fictícios.
- Favoritos e perfil são mantidos somente em memória.
- Não há autenticação ou autorização de usuários.
- Não há consulta ao banco de dados ou integração com API.
- Ações de WhatsApp, telefone, rota, avaliações e cadastro podem ser apenas demonstrativas.

## Repositório

[GitHub — Alisson-Teles/Simples_Fica](https://github.com/Alisson-Teles/Simples_Fica)
