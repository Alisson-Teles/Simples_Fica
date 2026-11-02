# SIMPLES FICA

**O que fica perto, fica fácil.**

O **Simples Fica** é um aplicativo mobile desenvolvido em **Flutter/Dart** para facilitar a descoberta de estabelecimentos, produtos e serviços da região. O projeto evolui por etapas: navegação pública, favoritos, perfis, formulários de cadastro e gerenciamento demonstrativo de negócios.

> **Situação desta entrega:** o código dos **acessos demonstrativos** (Cliente, Comerciante, Administrador e Visitante) foi preparado para integração local. Após aplicar os arquivos e executar os testes, o aplicativo abrirá a **LoginView depois da Splash**. **Não se trata de autenticação, cadastro persistente ou autorização real.** As senhas abaixo são exemplos públicos para testes, nunca credenciais de produção.

## Organização do repositório

O repositório é organizado em dois projetos independentes, ainda **sem integração funcional entre si**:

```text
Simples_Fica/
├── README.md                            # Apresentação geral (este arquivo)
├── simplesfica/                         # Aplicativo Flutter
│   ├── README.md                        # Instruções específicas do Flutter
│   ├── android/ ios/ linux/ macos/ web/ windows/
│   ├── lib/
│   ├── test/
│   ├── docs/                            # Documentação das entregas
│   ├── pubspec.yaml
│   ├── pubspec.lock
│   └── analysis_options.yaml
└── backsimplesfica/
    └── APISimplesFica/                   # Estrutura inicial de projeto .NET
        ├── APISimplesFica.slnx
        └── APISimplesFica/
            ├── Controllers/
            ├── Program.cs
            ├── appsettings.json
            └── APISimplesFica.csproj
```

A presença da pasta `backsimplesfica/` **não** significa que o aplicativo Flutter já utiliza a API ou um banco de dados. A camada de integração ainda precisa ser desenvolvida. Pastas temporárias do .NET, como `obj/` e `bin/`, não devem fazer parte de commits futuros.

## Tecnologias

- **Flutter / Dart:** aplicativo e formulários mobile, com Material Design 3.
- **ChangeNotifier + InheritedNotifier:** estado da sessão mantido na memória pelo `AppSession` e exposto pelo `AppScope`.
- **Flutter Test:** testes unitários do estado, negócios e acessos demonstrativos.
- **.NET:** projeto inicial de API presente em `backsimplesfica/`, ainda sem integração com as views.
- **SQL Server:** previsto para uma etapa posterior; não é utilizado no fluxo demonstrativo atual.

## Funcionalidades do protótipo

| Área | Funcionalidade | Situação |
|---|---|---|
| Apresentação | Splash e navegação | Implementada; abertura do Login no complemento de testes |
| Público | Home, Explorar, filtros, detalhes e avaliações de exemplo | Dados fictícios |
| Catálogo | Produtos/serviços e classificação por ofertas ativas | Em memória / mocks |
| Favoritos | Adicionar e remover entre as quatro abas | Em memória |
| Perfil | Exibição e edição de dados | Em memória |
| Cadastro | Tipo de conta, registro e recuperação de senha | Formulários sem servidor |
| Comerciante | Negócios, ofertas, estoque e vendas | Gerenciamento demonstrativo em memória |
| Assinatura/publicidade | Escolha de plano e prévia de anúncio | Simulação, sem contratação |
| Administrador | Prévia de indicadores e módulos futuros | Sem poderes administrativos reais |
| Acessos demonstrativos | Cliente, Comerciante, Administrador e Visitante | Contas fictícias locais, sem autenticação real |

## Acessar o aplicativo para testes

Depois de aplicar o complemento dos acessos demonstrativos, o fluxo é:

```text
SplashView → LoginView
               ├── Cliente ────────→ Início / Explorar / Favoritos / Perfil
               ├── Comerciante ────→ Abas públicas + Meus negócios (demo)
               ├── Administrador ──→ Abas públicas + Painel administrativo (prévia)
               └── Visitante ──────→ Abas públicas sem conta
```

A tela de Login oferece botões para **preencher as credenciais fictícias automaticamente**. Se preferir, digite os valores manualmente:

| Acesso | E-mail de teste | Senha de teste |
|---|---|---|
| Cliente | `cliente@simplesfica.test` | `Cliente123!` |
| Comerciante | `comerciante@simplesfica.test` | `Comerciante123!` |
| Administrador | `admin@simplesfica.test` | `Admin123!` |

Essas credenciais estão declaradas em `simplesfica/lib/data/contas_demo.dart`. **São dados públicos de demonstração, sem proteção de contas verdadeiras.** Não use senhas pessoais nos testes.

### O que cada perfil pode visualizar

- **Visitante:** Home, Explorar, Favoritos e Perfil; pode selecionar uma conta de teste posteriormente.
- **Cliente:** navegação pública, favoritos, edição do perfil local e opção de trocar de conta.
- **Comerciante:** navegação pública e acesso a **Perfil → Meus negócios (demo)**. O cenário inicial inclui a **Tech Cell — Demonstração**, com dois produtos, um serviço e uma venda de exemplo.
- **Administrador:** navegação pública e acesso a **Perfil → Painel administrativo (demo)**, que apenas apresenta contagens fictícias e os módulos previstos para a próxima etapa. **Não existe administração real ainda.**

**Trocar de conta ou sair limpa os dados temporários** do acesso anterior (favoritos, negócios, vendas e prévias de anúncio). Ao entrar como Comerciante novamente, o cenário inicial é recriado. Não há persistência após o encerramento do processo.

Os formulários **Criar conta** e **Esqueci a senha** seguem demonstrativos: não criam usuários nem enviam mensagens. As três contas acima são os únicos acessos predefinidos no código desse complemento.

## Estrutura de diretórios do Flutter

Os caminhos a seguir são relativos à pasta `simplesfica/`:

```text
simplesfica/
├── lib/
│   ├── main.dart                         # MaterialApp + AppScope
│   ├── data/
│   │   ├── contas_demo.dart              # Credenciais públicas de teste [NOVO]
│   │   ├── estabelecimentos_mock.dart    # Estabelecimentos fictícios
│   │   └── detalhes_mock.dart            # Ofertas, horários e avaliações fictícias
│   ├── models/
│   │   ├── conta_demo.dart               # Tipo de acesso e modelo [NOVO]
│   │   ├── estabelecimento.dart
│   │   ├── detalhes_estabelecimento.dart # Classificação automática
│   │   ├── negocio_demo.dart             # Negócios e vendas locais
│   │   ├── oferta.dart                   # Produto / serviço
│   │   ├── tipo_conta.dart               # Cliente/comerciante no cadastro
│   │   └── usuario_perfil.dart
│   ├── state/
│   │   ├── app_session.dart              # Sessão, favoritos, negócios, vendas [ATUALIZADO]
│   │   └── app_scope.dart                # Estado compartilhado para widgets
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   └── formatacao.dart
│   ├── views/
│   │   ├── core/
│   │   │   ├── splash_view.dart           # Abre o Login [ATUALIZADO]
│   │   │   └── main_navigation_view.dart # Quatro abas públicas
│   │   ├── auth/
│   │   │   ├── login_view.dart            # Acessos rápidos [ATUALIZADO]
│   │   │   ├── register_view.dart
│   │   │   ├── account_type_view.dart
│   │   │   └── forgot_password_view.dart
│   │   ├── account/
│   │   │   ├── profile_view.dart          # Menus conforme perfil [ATUALIZADO]
│   │   │   ├── favorites_view.dart
│   │   │   └── edit_profile_view.dart
│   │   ├── public/
│   │   │   ├── home_view.dart
│   │   │   ├── explore_view.dart
│   │   │   └── business_detail_view.dart
│   │   ├── merchant/
│   │   │   ├── merchant_dashboard_view.dart
│   │   │   ├── business_registration_view.dart
│   │   │   ├── edit_business_view.dart
│   │   │   ├── business_preview_view.dart
│   │   │   ├── offerings_view.dart
│   │   │   ├── offering_form_view.dart
│   │   │   ├── sales_view.dart
│   │   │   ├── subscription_view.dart
│   │   │   └── advertising_view.dart
│   │   └── admin/
│   │       └── admin_demo_view.dart       # Prévia da Etapa 6 [NOVO]
│   └── widgets/business/
│       └── estabelecimento_card.dart
├── test/
│   ├── widget_test.dart
│   ├── merchant_state_test.dart
│   └── demo_access_test.dart            # Testes dos acessos [NOVO]
├── docs/
│   └── SIMPLES_FICA_Commit_Acessos_Demonstrativos.md
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

Os arquivos identificados com **[NOVO]** e **[ATUALIZADO]** pertencem ao complemento de testes após a Etapa 5. A estrutura descreve o resultado esperado **depois que esses arquivos forem adicionados e publicados**.

## Regras principais preservadas

1. **Classificação do estabelecimento:** depende exclusivamente de ofertas **ativas**, não do tipo de conta do usuário. Produto ativo + serviço ativo = **Produtos e serviços**.
2. **Venda demonstrativa:** exige oferta ativa, preço positivo e quantidade válida; produtos exigem estoque suficiente. O registro reduz o saldo e soma uma receita fictícia, sem pagamento.
3. **Isolamento de contas de teste:** trocar/sair limpa a sessão anterior; não existe armazenamento permanente nem dados reais compartilhados.
4. **Separação de publicidade:** destacar uma oferta no catálogo não é o mesmo que contratar um anúncio; ambos os recursos são apenas demonstrativos neste estágio.
5. **Controle visual de perfil não é segurança:** a navegação oculta menus conforme o perfil selecionado, porém **nenhuma autorização real é fornecida**. O backend deverá impor permissões para todas as operações administrativas no futuro.

## Executar e verificar

Clone o repositório e entre na **subpasta Flutter**:

```bash
git clone https://github.com/Alisson-Teles/Simples_Fica.git
cd Simples_Fica/simplesfica
flutter pub get
flutter analyze
flutter test
flutter run
```

Para testar só os acessos:

```bash
flutter test test/demo_access_test.dart
```

O `flutter analyze` e os testes precisam ser executados localmente após copiar os códigos. Não há verificação de compilação ou publicação feita por esta documentação.

## Roadmap e próximos passos

| Etapa | Escopo | Situação desta entrega |
|---|---|---|
| 0–2 | Fundação, catálogo e detalhes públicos | Implementado em código |
| 3 | Favoritos e perfil | Implementado em código |
| 4 | Interfaces de login, cadastro e recuperação | Implementado, ainda sem backend |
| 5 | Área do comerciante (CRUD, estoque, vendas e prévias) | Implementado localmente, com testes a validar |
| Complemento 4/5 | **Acessos demonstrativos e cenário inicial do comerciante** | **Preparado para commit; validar no emulador** |
| 6 | Administração geral | A prévia de acesso existe; painel completo pendente |
| 7–8 | Configurações, revisão de UX e testes finais | Planejado |

### Integração com a API

O repositório já contém um projeto .NET inicial em `backsimplesfica/`, **ainda não conectado** ao Flutter. Para evoluir além do protótipo, serão necessários autenticação e autorização no servidor, persistência de contas/negócios/ofertas/vendas e comunicação HTTP entre app e API. Não armazenar segredos de produção no app nem estabelecer conexão direta do Flutter com SQL Server.


## Repositório

[GitHub — Alisson-Teles/Simples_Fica](https://github.com/Alisson-Teles/Simples_Fica)
