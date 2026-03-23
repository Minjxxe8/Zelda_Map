# Les Copines

Application Flutter connectée à Supabase pour partager une photo par jour, consulter le feed du jour, liker les posts et voir les profils des autres utilisateurs.

## Fonctionnalités

- Authentification par email et mot de passe
- Feed du jour avec nom d'utilisateur, heure du post et likes
- Like sur les photos
- Capture et upload de photo avec `image_picker`
- Profil personnel et profils publics
- Possibilité de poster une photo par jour dans un groupe
- Interface responsive :
  - mobile : liste verticale sur l'accueil
  - tablette : grille sur l'accueil

## Stack

- Flutter
- Riverpod
- Supabase
- `flutter_dotenv`
- `image_picker`

## Lancement du projet

### Prérequis

- Flutter installé et accessible dans le `PATH`
- Un projet Supabase configuré
- Un fichier `.env` à la racine du projet

### 1. Installer les dépendances

```powershell
flutter pub get
```

### 2. Créer le fichier `.env`

Le fichier doit être placé ici :

[` .env `](C:\Users\elisa\Desktop\Dev mobile - 23 mars\Zelda_Map\.env)

Contenu minimal :

```env
SUPABASE_URL=https://votre-projet.supabase.co
SUPABASE_ANON_KEY=votre_cle_anon
```

### 3. Lancer l'application

```powershell
flutter run
```

Pour tester la caméra réelle, préfère un téléphone Android ou iPhone. Sur Windows desktop, `image_picker` ne reproduit pas le comportement complet de la caméra mobile.

## Structure du projet

```text
lib/
├─ main.dart
├─ providers/
├─ repository/
├─ services/
├─ ui/
│  ├─ authentification/
│  ├─ feed/
│  ├─ groups/
│  ├─ photos/
│  ├─ profile/
│  └─ widgets/
└─ utils/
```

## Parcours principal

- [`main.dart`](C:\Users\elisa\Desktop\Dev mobile - 23 mars\Zelda_Map\lib\main.dart)
  - initialise `.env`
  - initialise Supabase
  - démarre l'écran d'authentification
- [`app_shell.dart`](C:\Users\elisa\Desktop\Dev mobile - 23 mars\Zelda_Map\lib\ui\app_shell.dart)
  - navigation principale :
    - accueil
    - groupes
    - prendre une photo
    - profil
- [`feed_screen.dart`](C:\Users\elisa\Desktop\Dev mobile - 23 mars\Zelda_Map\lib\ui\feed\feed_screen.dart)
  - affiche les photos publiées aujourd'hui
- [`group_screen.dart`](C:\Users\elisa\Desktop\Dev mobile - 23 mars\Zelda_Map\lib\ui\groups\group_screen.dart)
  - affiche les pgroupes que l'on as rejoint, et et les groupes disponibles
- [`photo_capture_screen.dart`](C:\Users\elisa\Desktop\Dev mobile - 23 mars\Zelda_Map\lib\ui\photos\photo_capture_screen.dart)
  - ouvre la caméra et envoie la photo, avec une légende personnalisée et un mode (public ou groupe)
- [`profile_screen.dart`](C:\Users\elisa\Desktop\Dev mobile - 23 mars\Zelda_Map\lib\ui\profile\profile_screen.dart)
  - affiche le profil connecté

## Schéma Supabase attendu

Le code actuel suppose au minimum les tables et colonnes suivantes :

### `profiles`

- `id`
- `username`
- `email`

### `photos`

- `id`
- `user_id`
- `image_url`
- `caption`
- `mode`
- `created_at`

### `photo_likes`

- `id`
- `photo`
- `user`

## Remarques importantes

- Le fichier `.env` est déclaré dans [`pubspec.yaml`](C:\Users\elisa\Desktop\Dev mobile - 23 mars\Zelda_Map\pubspec.yaml). S'il manque, le build Flutter échoue.
- Les policies RLS Supabase doivent autoriser la lecture et l'insertion dans `photo_likes`, sinon les likes seront bloqués.
- Le projet contient une UI dark custom avec logo et barre de navigation personnalisée.

## Vérifications utiles

```powershell
flutter analyze
flutter test
```

## Auteurs

<a href="https://github.com/elirbl"><img src="https://avatars.githubusercontent.com/u/186811170?v=4" alt="Elisabeth Robl" width="69" height="69"/></a>
<a href="https://github.com/Minjxxe8"><img src="https://avatars.githubusercontent.com/u/137718998?v=4" alt="Ricard Léna" width="69" height="69"/></a>

