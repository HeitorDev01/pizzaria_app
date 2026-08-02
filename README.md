# pizzaria_app

App de delivery de pizza em Flutter, com autenticacao via Firebase e
gerenciamento de estado em BLoC.

## Rodando

```bash
flutter pub get
flutter run
```

Configuracao de seguranca e checklist do console Firebase: veja
[SECURITY.md](SECURITY.md).

## Estrutura

Organizacao **feature-first**: cada funcionalidade guarda junto o seu estado
e as suas telas, em vez de espalhar por pastas globais de `blocs/` e
`screens/`.

```
lib/
├─ main.dart                    ponto de entrada: Firebase + runApp
├─ app/                         montagem do app
│  ├─ app.dart                  injecao do repositorio e do bloc de auth
│  ├─ app_view.dart             MaterialApp e roteamento por estado de login
│  ├─ theme.dart                cores e tema
│  └─ bloc_observer.dart        log dos blocs (silencioso em release)
├─ core/                        o que e compartilhado entre features
│  ├─ config/                   firebase_options.dart (gerado)
│  ├─ validators/               regras de e-mail, senha e nome
│  └─ widgets/                  widgets genericos (AppTextField)
└─ features/
   ├─ auth/
   │  ├─ bloc/                  authentication, sign_in, sign_up
   │  ├─ view/                  welcome, sign_in, sign_up
   │  └─ widgets/               widgets so da autenticacao
   └─ home/
      └─ view/

packages/
├─ user_repository/             camada de dados de usuario
└─ pizza_repository/            reservado (ainda sem codigo)
```

### Regras que a estrutura segue

- **A UI nao conhece o Firebase.** As telas e os blocs dependem da interface
  `UserRepository`; so `packages/user_repository` importa `firebase_auth` e
  `cloud_firestore`. Trocar de backend nao toca em `lib/`.
- **`core/` nao importa de `features/`.** A dependencia anda em uma direcao
  so. Se dois features precisam da mesma coisa, ela sobe para `core/`.
- **Validacao mora em um lugar so.** `core/validators/validators.dart` e a
  fonte unica das regras de e-mail e senha, usada tanto pelos campos de
  formulario quanto pelo checklist de requisitos do cadastro.
- **Um bloc por fluxo.** `AuthenticationBloc` responde apenas "ha usuario
  logado?"; entrar e cadastrar tem cada um o seu bloc, com ciclo de vida
  preso a tela.
