# SIMPLES FICA

**O que fica perto, fica fácil.**

O **Simples Fica** é um aplicativo mobile em **Flutter/Dart** para encontrar estabelecimentos, produtos e serviços locais. A evolução do projeto segue etapas documentadas; a **Etapa 6 — Administração Geral** acrescenta painéis de acompanhamento e regras demonstrativas que conectam **Administração, Comerciante e áreas públicas**.

> **Status da entrega:** este README documenta o **estado-alvo local após aplicar a Etapa 6 e seus complementos**. Na última consulta à branch remota `main`, parte dos arquivos da Etapa 6 ainda não estava publicada. Execute a validação local antes do commit. Não existe autenticação, autorização, cobrança, moderação ou sincronização real entre dispositivos.

## Estrutura do repositório

```text
Simples_Fica/
├── README.md
├── simplesfica/                      # Flutter / Dart (aplicativo mobile)
│   ├── README.md
│   ├── lib/
│   ├── test/
│   ├── docs/
│   │   └── SIMPLES_FICA_Commit_Etapa_6.md
│   └── pubspec.yaml
└── backsimplesfica/                 # Projeto inicial de API .NET, separado
    └── APISimplesFica/
```

O projeto `.NET` existente **não está integrado** ao Flutter e a aplicação não acessa diretamente o SQL Server. O desenvolvimento atual é um protótipo funcional **em memória no mesmo processo**.

## Tecnologias

- **Flutter / Dart / Material:** interface mobile e navegação.
- **`ChangeNotifier` + `InheritedNotifier` (`AppSession` / `AppScope`):** compartilhamento dos estados demonstrativos entre as views.
- **`AdminDemoState`:** estado administrativo compartilhado na sessão, com situações, publicação, anúncios, indicadores, denúncias e auditoria.
- **`Flutter Test`:** testes do catálogo, regras administrativas, clientes, comerciantes e interfaces.
- **API .NET / SQL Server:** estrutura em desenvolvimento, **sem uso pelo aplicativo nesta entrega**.

## Acesso à demonstração

O fluxo de testes é **Splash → Login → Home / Explorar / Favoritos / Perfil**. Na aba Perfil, cada conta visualiza os atalhos de seu papel demonstrativo.

| Perfil | E-mail público de teste | Senha fictícia |
|---|---|---|
| Cliente | `cliente@simplesfica.test` | `Cliente123!` |
| Comerciante | `comerciante@simplesfica.test` | `Comerciante123!` |
| Administrador | `admin@simplesfica.test` | `Admin123!` |
| Visitante | Não requer credenciais | — |

Essas credenciais estão em `simplesfica/lib/data/contas_demo.dart`, são deliberadamente públicas e **não devem ser usadas com dados reais**. Os formulários Criar conta e Esqueci a senha continuam demonstrativos.

## Funcionalidades por etapa

| Etapa | Escopo | Condição descrita |
|---|---|---|
| 0–2 | Estrutura, Home, Explorar, detalhes e catálogo | Catálogo fictício com ofertas e classificação por atuação |
| 3 | Favoritos e perfil | Estado local e interface pública |
| 4 + complemento | Login visual, cadastro, recuperação e contas de teste | Sem autenticação real |
| 5 | Área do comerciante | CRUD local de negócios/ofertas; estoque, vendas, prévias de assinatura/anúncio |
| **6** | **Administração Geral** | **Sete módulos, indicadores interativos, suspensão e publicação vinculadas à navegação pública (código para validar localmente)** |
| 7–8 | Telas auxiliares, refinamento, testes de revisão | Próximas etapas |

### Etapa 6 — módulos administrativos

| Tela | Responsabilidade |
|---|---|
| `AdminDashboardView` | Indicadores interativos, gráficos fictícios e atalhos |
| `BusinessManagementView` | Busca/filtro por situação e atuação; simular suspensão, reativação e publicação |
| `UsersManagementView` | Pesquisa e filtros de Cliente, Comerciante e Administrador; estados ativo/inativo/suspenso/bloqueado |
| `FinancialOverviewView` | Pagamentos demonstrativos e indicadores de receita aprovada/inadimplência; somente consulta |
| `AdsManagementView` | Anúncios fictícios ativos/pausados e elegibilidade pública |
| `AuditLogsView` | Registro local das alterações realizadas no painel |
| `ReportsView` | Denúncias fictícias e simulação de análise/arquivamento |

### Indicadores interativos

Os cartões abrem as telas correspondentes, com filtros iniciais quando aplicável:

- **Pessoas:** Clientes, Clientes ativos, Clientes inativos (inclui suspensos/bloqueados), Clientes suspensos e Contas de comerciante.
- **Estabelecimentos:** Comerciantes/Prestadores (total com ofertas ativas), Somente comerciantes, Somente prestadores, Ambos, Negócios ativos, Suspensos, Comerciantes suspensos, Prestadores suspensos, Ambos suspensos e indicador de Visíveis ao público quando incluído no Dashboard local.
- **Operação:** Inadimplentes, Receita aprovada (demo), Anúncios ativos elegíveis e Denúncias pendentes.

**Contas de comerciante ≠ estabelecimentos comerciais.** Uma conta é um registro de usuário; um negócio é um cadastro de estabelecimento. **Ambos** é uma classificação exclusiva para estabelecimentos com produtos **e** serviços ativos, sem contagem duplicada.

## Regras compartilhadas de disponibilidade

A Etapa 6 corrige a inconsistência entre o painel administrativo e as telas públicas. A referência é o `AdminDemoState` compartilhado pelo `AppSession` durante a execução.

```text
                   AppSession / AppScope
                           │
                    AdminDemoState
                (situação + publicação)
                           │
          ┌────────────────┼────────────────┐
          │                │                │
       Home/Explorar    Comerciante     Administração
       e detalhes      (cadastros)     (moderação demo)
```

Um estabelecimento aparece na Home e na Explorar **somente quando está administrativamente ativo e publicado**. Estabelecimentos suspensos e inativos permanecem no cadastro administrativo, mas não são mostrados publicamente. O campo `aberto` usado em alguns mocks é **horário/funcionamento fictício** e **não** indica situação administrativa.

| Situação | Registro administrativo | Home/Explorar | Publicidade pública |
|---|---|---|---|
| Ativo e publicado | Sim | Sim | Apenas se houver anúncio ativo elegível |
| Ativo e não publicado | Sim | Não | Não |
| Suspenso | Sim | Não | Não |
| Inativo | Sim | Não | Não |

**Referência inicial dos cinco mocks:** 5 cadastrados, 3 ativos/publicados/visíveis, 1 suspenso (**Barbearia Moderna**) e 1 inativo (**Oficina Rápida**). Classificação de atuação: 2 somente comerciantes, 2 somente prestadores e 1 ambos (**Tech Cell**). Esses valores **mudam** com as ações de teste e com cadastros adicionais; não são números fixos do sistema.

A Home separa anúncios patrocinados de resultados orgânicos. A Explorar aplica pesquisa, cidade, categoria, atuação, avaliação e horário **após** filtrar a disponibilidade. Favoritos de um negócio indisponível podem continuar salvos, mas devem aparecer sinalizados e sem ações comerciais; a tela de detalhes verifica novamente a situação.

### Fluxo Comerciante → Administrador → Cliente

1. Comerciante cadastra um negócio e suas ofertas no painel local.
2. O cadastro aparece na Administração como **não publicado**; não entra automaticamente na Home/Explorar.
3. Administrador pode publicar somente negócio **ativo e com pelo menos uma oferta ativa**.
4. O Cliente passa a encontrá-lo nas telas públicas enquanto a execução do app permanecer ativa.
5. Se o Administrador suspender o negócio, ele some imediatamente das listas públicas e dos anúncios elegíveis, **mas permanece no cadastro administrativo**.
6. Editar o negócio ou suas ofertas no painel comercial não deve retirar a suspensão administrativa.

Ao trocar de conta, os **favoritos do perfil de teste são limpos**, mas os **cadastros/estados demonstrativos de negócios permanecem em memória** para permitir a validação desse fluxo entre perfis. A memória é reiniciada quando o processo do app é reiniciado; **não há persistência nem sincronização entre celulares**.

## Executar e testar

Abra um terminal na pasta `simplesfica/` (onde está o `pubspec.yaml`):

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Testes da Etapa 6 e da integração:

```bash
flutter test test/admin_demo_state_test.dart
flutter test test/admin_dashboard_metrics_test.dart
flutter test test/admin_business_metrics_test.dart
flutter test test/admin_suspension_metrics_test.dart
flutter test test/catalogo_integrado_test.dart
```

Os nomes acima correspondem aos arquivos entregues durante as implementações; confirme que todos foram copiados para `test/`. É necessário verificar também os testes antigos (`demo_access_test.dart`, `merchant_state_test.dart` e `widget_test.dart`) para regressões.

A etapa **não é considerada publicada apenas por estar documentada**. Verifique o funcionamento no emulador, o resultado de `flutter analyze`/`flutter test` e o diff do Git antes do push.

## Limitações e próximos passos

- `ehAdministrador` é uma regra visual/local; **não é autenticação nem autorização confiável**.
- Suspensões, publicações, receitas, anúncios e denúncias são **simulações**; nenhuma alteração é aplicada em dispositivos de terceiros.
- O controle de publicação e a auditoria existem somente em memória; não há recuperação após reinício do processo.
- Compras e vendas do comerciante são fictícias, sem pagamento.
- Métricas de distância, horários e avaliações dos novos negócios locais ainda não são calculadas por serviços reais.
- Próxima evolução: **Flutter → API .NET → SQL Server**, com autenticação/autorização no servidor, propriedade dos negócios, persistência, moderação, métricas e auditoria durável. Não conectar o Flutter diretamente ao SQL Server nem colocar segredos de produção no aplicativo.


Repositório: [Alisson-Teles/Simples_Fica](https://github.com/Alisson-Teles/Simples_Fica).
