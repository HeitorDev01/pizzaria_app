# Seguranca do pizzaria_app

Este repositorio e **publico**. Este documento separa o que pode ficar
visivel do que nunca pode, e lista o que precisa ser feito no console.

## O que e publico por design (pode ficar no repo)

| Arquivo | Conteudo | Por que e seguro |
|---|---|---|
| `lib/firebase_options.dart` | apiKey, appId, projectId | Chave de **cliente**. Vai embutida no APK e no bundle web de qualquer jeito — qualquer pessoa extrai do app instalado. |
| `android/app/google-services.json` | mesmo conjunto | Idem. |
| `firebase.json` | projectId, appIds | Identificadores, nao credenciais. |

Uma `apiKey` do Firebase **nao autoriza nada sozinha**. Ela apenas
identifica o projeto. Quem decide o que pode ser lido ou escrito sao as
Security Rules. Remover esses arquivos do Git nao aumenta a seguranca em
nada — so quebra o build de quem clonar o projeto.

## O que nunca pode entrar no repo

Ja bloqueado no `.gitignore`:

- `.env` e variantes — segredos de backend (gateway de pagamento, SMTP)
- `*.jks`, `*.keystore`, `android/key.properties` — quem tem isso publica
  app no seu nome na Play Store
- `firebase-adminsdk-*.json`, `serviceAccountKey*.json` — **service account
  tem poder de admin e ignora todas as Security Rules**. Este e o vazamento
  que realmente derruba o projeto.
- `*.pem`, `*.p8`, `*.p12` — chaves privadas
- `*.sql`, `*.dump`, `*_export.json` — exports com dados de cliente

## Onde os dados de cliente realmente ficam expostos

O app grava `name` e `email` de cada cliente em `users/{uid}`
(`packages/user_repository/lib/src/firebase_user_repo.dart`).

A unica barreira entre essa coleção e a internet sao as Security Rules,
que rodam no servidor do Google. O codigo do app nao protege nada: um
atacante nao usa seu app, ele chama a API REST do Firestore direto com o
`projectId` — que e publico.

As regras estao em `firestore.rules` e `storage.rules`. Modelo adotado:
nega tudo por padrao, libera o minimo.

### Publicar as regras

```bash
firebase deploy --only firestore:rules,storage
```

Enquanto nao publicar, o que vale e o que esta no console, nao o que esta
neste repositorio.

## Checklist manual (console — nao da pra fazer por codigo)

- [ ] **Conferir se o Firestore esta em modo de teste.** Console > Firestore
      > Regras. Se aparecer `allow read, write: if request.time < ...`, a
      base de clientes esta aberta pra qualquer um agora. Prioridade maxima.
- [ ] Publicar `firestore.rules` e `storage.rules`.
- [ ] **Restringir as API keys**: Google Cloud Console > APIs e Servicos >
      Credenciais. Para a chave Android, restringir por nome de pacote +
      fingerprint SHA-1. Para a chave web, restringir por dominio HTTP.
      Sem isso a chave funciona a partir de qualquer lugar.
- [ ] **Ativar o App Check** (Play Integrity no Android, reCAPTCHA no web).
      Garante que so o seu app de verdade fala com o Firebase.
- [ ] Authentication > Settings > **habilitar protecao contra enumeracao
      de e-mail**. Sem isso da pra descobrir quais e-mails tem conta.
- [ ] Trocar o applicationId `com.example.pizzaria_app` antes de publicar.
- [ ] Definir cota de gasto / alerta de budget — Storage e Firestore
      abertos viram conta alta rapido.

## Pendencia conhecida no codigo

`firebase_user_repo.dart` usa `log(e.toString())` nos catch de login e
cadastro. Em build de release isso joga a mensagem bruta do Firebase Auth
no logcat, que outros apps do aparelho conseguem ler em alguns cenarios.
Trocar por uma mensagem generica na UI e manter o detalhe so em debug.
