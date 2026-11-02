# SIMPLES FICA

**O que fica perto, fica fácil.**

O **Simples Fica** é um protótipo mobile em **Flutter e Dart** para encontrar comércios e prestadores de serviços locais. O projeto progride por etapas, com código-fonte e documentação versionados. A **Etapa 7 — Informações e telas auxiliares** adiciona orientações, ajuda, configurações, estados reutilizáveis de interface e corrige a separação dos favoritos por conta demonstrativa.

> **Estado da entrega:** este README descreve a **Etapa 7 preparada para commit local**. A branch `main` consultada em **02/11/2026** continha a Etapa 6, mas ainda não os novos arquivos da Etapa 7. Não é declaração de que os testes Flutter foram executados ou de que o commit já foi publicado. A API .NET ainda é um projeto inicial, não integrado ao aplicativo.

## Organização do repositório

```text
Simples_Fica/
├── README.md
├── simplesfica/                         # Aplicativo Flutter
│   ├── README.md
│   ├── pubspec.yaml
│   ├── lib/
│   │   ├── main.dart
│   │   ├── data/                       # Dados fictícios atuais
│   │   ├── models/
│   │   ├── state/                      # AppSession, AppScope, AdminDemoState
│   │   ├── views/
│   │   │   ├── auth/  core/  account/
│   │   │   ├── public/  merchant/  admin/
│   │   │   └── info/                   # Etapa 7
│   │   └── widgets/
│   │       ├── business/
│   │       └── common/                 # Etapa 7
│   ├── test/
│   └── docs/
│       ├── SIMPLES_FICA_Commit_Etapa_7.md
│       └── PLANO_INTEGRACAO_BACKEND.md
└── backsimplesfica/
    └── APISimplesFica/
        └── APISimplesFica/             # Projeto ASP.NET Core .NET 10 inicial
```

Na estrutura remota verificada, a API possui `Program.cs`, o controlador exemplo `WeatherForecastController.cs` e seus arquivos de configuração. **Ainda não há implementação de autenticação, endpoints do domínio Simples Fica nem persistência SQL Server no repositório.**

## Contas públicas de demonstração

| Acesso | E-mail fictício | Senha fictícia |
|---|---|---|
| Cliente | `cliente@simplesfica.test` | `Cliente123!` |
| Comerciante | `comerciante@simplesfica.test` | `Comerciante123!` |
| Administrador | `admin@simplesfica.test` | `Admin123!` |
| Visitante | Sem login | — |

**Uso exclusivo de teste.** As credenciais ficam em `lib/data/contas_demo.dart`; não constituem autenticação segura. Nunca armazenar senhas reais nesse arquivo.

## Evolução das etapas

| Etapa | Entrega no protótipo |
|---|---|
| 0–2 | Base Flutter, Home, Explorar, detalhes, categorias e ofertas fictícias |
| 3 | Favoritos, Perfil e navegação pública |
| 4 e complemento | Interfaces de acesso/cadastro/recuperação e três contas pré-configuradas de demonstração |
| 5 | Área de Comerciante, CRUD local de negócios/ofertas, vendas/estoque, prévias de publicidade/assinatura |
| 6 e complementos | Administração Geral, indicadores interativos, classificação por atuação, suspensão, publicação e catálogo compartilhado |
| **7** | **Como funciona, Ajuda, Configurações, tela de conteúdo indisponível, feedback comum e favoritos separados por conta** |
| 8 | Consolidação, testes e revisão — **próxima etapa** |

### Etapa 6 — regras preservadas

O `AppSession` compartilha `AdminDemoState` com Home, Explorar, Favoritos e Administração. Um estabelecimento só é público quando está **ativo e publicado**. Suspensos e inativos permanecem no cadastro administrativo, mas não aparecem nas consultas públicas nem em anúncios elegíveis. `aberto`/`fechado` nos dados fictícios descrevem horário, e não situação administrativa.

A classificação **Somente comerciantes / Somente prestadores / Ambos** é calculada a partir das ofertas ativas, sem duplicação. O painel também distingue contas de comerciante de cadastros de estabelecimentos. Um novo negócio feito no painel comercial começa **não publicado**; ativação/publicação dependem das regras administrativas demonstrativas.

### Etapa 7 — novas telas

| Tela / componente | Função |
|---|---|
| `lib/views/info/how_it_works_view.dart` | Explica busca local, resultados patrocinados, favoritos, contato e cadastro |
| `lib/views/info/help_view.dart` | FAQ pesquisável por assunto e perfil, com perguntas expansíveis |
| `lib/views/info/settings_view.dart` | Mostrar dicas, confirmar antes de sair, restaurar preferências e informar o tema atual |
| `lib/views/info/not_found_view.dart` | Mensagem e saída para rotas inválidas e estabelecimentos indisponíveis |
| `lib/widgets/common/app_feedback.dart` | Estados vazios, carregamento, erro, confirmação e SnackBar reutilizáveis |

As novas páginas são acessíveis pelo Perfil. `main.dart` passa a tratar rota desconhecida, e a página pública de detalhes reutiliza o estado de indisponibilidade.

### Correção de favoritos

Os favoritos são agora **separados por conta fictícia** (Cliente, Comerciante, Administrador e Visitante) no `AppSession`. Trocar de perfil ou sair **não apaga** a lista daquela conta enquanto o processo do aplicativo continuar vivo. Um favorito suspenso continua salvo, mas é identificado como indisponível; se reativado, volta à consulta normal. A chave do perfil demonstrativo é estável e não depende do e-mail editado no formulário de perfil.

**Atenção:** isso **não** significa persistência em disco. Reiniciar o processo remove favoritos e configurações atuais. Não há sincronização entre dispositivos. A publicação, a moderação e a autorização também continuam locais e fictícias.

## Executar e validar

Entre na pasta Flutter (que contém `pubspec.yaml`):

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Testes novos da Etapa 7, após copiar os arquivos:

```bash
flutter test test/favoritos_por_conta_test.dart
flutter test test/etapa7_views_test.dart
```

Fluxo de validação sugerido: favoritar **Tech Cell** como Cliente → sair → entrar como Administrador → suspender Tech Cell → voltar como Cliente → conferir favorito indisponível → reativar → verificar retorno. Testar também FAQ, recuperação de pesquisa vazia, preferências e tela de destino desconhecido. **Executar a suíte antiga também**, especialmente a de acessos e catálogo integrado, porque a regra de favoritos mudou.

## Integração futura: Flutter → API .NET → SQL Server

A API precisa ser a fonte de verdade de usuários, favoritos, proprietários dos negócios, ofertas, publicação, suspensão, anúncios, vendas, assinaturas e auditoria. O Flutter não deve conectar diretamente ao SQL Server. São necessários autenticação real, autorização por papel e propriedade, HTTPS, DTOs/versionamento, paginação, validação, tratamento de erros e testes de integração. Nenhum segredo deve ficar no código mobile ou no Git.

**Inventário por arquivo e plano de migração:** [`simplesfica/docs/PLANO_INTEGRACAO_BACKEND.md`](https://docs.google.com/document/d/1_Kn1LhqMG5si8kilgqcIOaWcqKr1VU0W0sSb8oLeQ6Q/edit?usp=sharing).

Repositório: [Alisson-Teles/Simples_Fica](https://github.com/Alisson-Teles/Simples_Fica).
