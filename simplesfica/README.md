# Simples Fica — Aplicativo Flutter

**O que fica perto, fica fácil.**

Este diretório contém o aplicativo mobile **Flutter/Dart** do projeto Simples Fica. Para a visão geral do repositório, incluindo a pasta da API .NET, consulte o [README principal](../README.md).

> **Estado atual:** interfaces e regras locais demonstrativas, sem autenticação real, persistência ou integração com o backend. O complemento de testes oferece contas fictícias de Cliente, Comerciante e Administrador, além de acesso como Visitante.

## Executar

Abra o terminal nesta pasta (`simplesfica/`, onde está o `pubspec.yaml`):

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Para executar apenas os testes do complemento de acessos:

```bash
flutter test test/demo_access_test.dart
```

## Acessos de teste (sem backend)

Depois de aplicar os arquivos do complemento, a **Splash** abre a **LoginView**, que tem botões para preencher automaticamente as credenciais:

| Perfil | E-mail | Senha fictícia |
|---|---|---|
| Cliente | `cliente@simplesfica.test` | `Cliente123!` |
| Comerciante | `comerciante@simplesfica.test` | `Comerciante123!` |
| Administrador | `admin@simplesfica.test` | `Admin123!` |

Também existe **Continuar como visitante**. As credenciais são públicas e existem somente para testar a interface. **Não usar senhas reais.**

O comerciante recebe um cenário inicial com **Tech Cell — Demonstração**, dois produtos, um serviço e uma venda fictícia de R$ 59,80. O Administrador vê somente uma **prévia** de indicadores e módulos previstos para a Etapa 6, não um painel real de controle.

Trocar de conta ou sair limpa os dados temporários da sessão anterior. O cadastro e a recuperação de senha continuam apenas validando formulários, sem criar usuários ou enviar e-mails.

## Organização de `lib/`

```text
lib/
├── main.dart
├── data/
│   ├── contas_demo.dart             # Contas fictícias de teste
│   ├── estabelecimentos_mock.dart
│   └── detalhes_mock.dart
├── models/
│   ├── conta_demo.dart              # Enum de acesso e ContaDemo
│   ├── estabelecimento.dart
│   ├── detalhes_estabelecimento.dart
│   ├── negocio_demo.dart
│   ├── oferta.dart
│   ├── tipo_conta.dart
│   └── usuario_perfil.dart
├── state/
│   ├── app_session.dart             # Acessos, favoritos, negócios e vendas em memória
│   └── app_scope.dart
├── theme/
│   └── app_theme.dart
├── utils/
│   └── formatacao.dart
├── views/
│   ├── core/                        # Splash e navegação inferior
│   ├── auth/                        # Login, cadastro e recuperação
│   ├── account/                     # Perfil e favoritos
│   ├── public/                      # Home, busca e detalhes
│   ├── merchant/                    # Área comercial demonstrativa
│   └── admin/
│       └── admin_demo_view.dart     # Prévia administrativa
└── widgets/business/               # Cartões de estabelecimentos

test/
├── widget_test.dart
├── merchant_state_test.dart
└── demo_access_test.dart

docs/
└── SIMPLES_FICA_Commit_Acessos_Demonstrativos.md
```

Os arquivos de acessos demonstrativos listados acima dependem da aplicação do complemento e de sua publicação no repositório.

## Regras e limites

- A classificação de negócios depende das **ofertas ativas**, independentemente do tipo de conta.
- As vendas de teste verificam disponibilidade, estoque e preço, mas não realizam pagamento real.
- Os negócios criados no painel ainda não são publicados na Home/Explorar.
- As ações de assinatura e publicidade são simulações locais.
- Acesso de Comerciante/Administrador é **simulação de navegação**, não autenticação ou autorização segura.
- Os dados demonstrativos desaparecem quando a sessão é reiniciada ou o usuário troca de conta.


A API .NET em `../backsimplesfica/` está separada e ainda não integrada às telas Flutter.
