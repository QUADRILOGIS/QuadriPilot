# 🚚 QuadriPilot

<p align="center">
  <strong>Application mobile pour les livreurs de remorques Quadrilogis</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Android-APK-3DDC84?logo=android&logoColor=white" alt="Android">
</p>

---

## 👥 Équipe de développement

Cette application a été réalisée par une équipe de la **promotion FIL A2 2025/2026** de l'**IMT Atlantique** :

| Nom                         | Rôle                      |
| --------------------------- | ------------------------- |
| **Pacôme CAILLETEAU**       | Développeur Back          |
| **Nathaniel GUITTON**       | Concepteur BDD            |
| **Liam LE NY**              | Développeur Front Web     |
| **Baptiste BAYCHE**         | Développeur Front Web     |
| **Marina CARBONE**          | Designeuse                |
| **Camille GOUAULT--LAMOUR** | Développeuse Front Mobile |

---

## 🎯 Objectif

QuadriPilot est l'application mobile destinée aux livreurs pour :

- se connecter à la carte électronique de la remorque
- démarrer et arrêter une livraison
- remonter des incidents terrain
- consulter les alertes de maintenance
- synchroniser les données vers l'API

---

## 🧱 Stack technique

- Flutter (mobile Android)
- Dart
- i18n (fr/en)
- Connexion API via HTTP
- File d'attente offline (synchronisation différée)

---

## 🔌 API QuadriCore

QuadriPilot consomme l'API **QuadriCore** pour :

- envoyer les incidents
- envoyer la position GPS du téléphone
- récupérer les alertes de maintenance

---

## 🚀 Installation (développeur)

```bash
# Installer les dépendances
flutter pub get
```

---

## ⚙️ Configuration

Créez un fichier `.env` à la racine du projet :

```env
API_BASE_URL=http://IP_DU_PC:3001/api
```

**Important :** le téléphone et le PC doivent être sur le même Wi-Fi.

### Trouver l'adresse IP LAN de votre PC

#### Windows
```bash
ipconfig
```
Cherchez **Adresse IPv4**.

#### macOS
```bash
ipconfig getifaddr en0
```
(ou `en1` si besoin)

#### Linux
```bash
ip a
```
Cherchez la ligne `inet` de la carte Wi-Fi.

### Exemples d'IP LAN
- `192.168.1.42`
- `192.168.0.15`
- `10.0.0.12`

Exemple complet :
```
API_BASE_URL=http://192.168.1.42:3001/api
```

---

## 🏃 Lancement

```bash
# Lancer en mode développement
flutter run

# Générer les traductions
flutter gen-l10n

# Analyser le code
flutter analyze
```

---

## 📦 APK (installation sur téléphone)

```bash
# Générer un APK debug
flutter build apk --debug
```

Fichier généré :
```
build/app/outputs/flutter-apk/app-debug.apk
```

Installer sur un téléphone connecté :
```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

---

## 📁 Structure

```
lib/
  core/          # config + i18n
  data/          # services + modèles
  logic/         # cubits / états
  ui/            # pages + widgets
assets/          # images + logos
```

---

## 🌍 Internationalisation

Traductions gérées dans :

- `lib/core/l10n/app_fr.arb`
- `lib/core/l10n/app_en.arb`

---

<p align="center">
  <strong>QuadriPilot</strong> - IMT Atlantique - FIL A2 2025/2026
</p>
