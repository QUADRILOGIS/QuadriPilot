# QuadriPilot — Guide simple

Ce guide est écrit pour quelqu’un qui n’est **pas informaticien**.  
Il explique comment **installer l’application** sur un téléphone Android et comment **la faire fonctionner**.

---

## Équipe d'étudiants pour Quadrilogis
- Baptiste BAYCHE
- Pacôme CAILLETEAU
- Marina CARBONE
- Camille GOUAULT--LAMOUR
- Nathaniel GUITTON
- Liam LE NY

---

## Ce qu’il vous faut (très simple)
1. Un téléphone Android
2. Un ordinateur (celui qui contient le projet)
3. Le Wi‑Fi **du même réseau** pour le téléphone et le PC
4. Le serveur API QuadriCore qui tourne en local sur l’ordinateur

---

## Étape 1 — Démarrer l’API (QuadriCore)
Sur l’ordinateur :
1. Ouvrir le dossier **QuadriCore**
2. Lancer l’API (demander à un développeur si besoin)
3. Vérifier que l’API répond :
   - Ouvrir dans le navigateur du téléphone :
     ```
     http://IP_DU_PC:3001/api/health
     ```
   - Si vous voyez une réponse, c’est bon.

---

## Étape 2 — Préparer l’adresse de l’API
Dans ce projet, il y a un fichier `.env` **(non visible si vous n’êtes pas développeur)**.

Ce fichier doit contenir :
```
API_BASE_URL=http://IP_DU_PC:3001/api
```

**Important :**  
Le téléphone et l’ordinateur doivent être sur **le même Wi‑Fi**.

---

## Étape 3 — Installer l’application sur Android
Un développeur doit générer un fichier APK :

```
flutter build apk --debug
```

Le fichier est ici :
```
build/app/outputs/flutter-apk/app-debug.apk
```

Ensuite, on installe l’APK sur le téléphone :
```
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

---

## Étape 4 — Utiliser l’application
1. Ouvrir l’app **QuadriPilot**
2. Se connecter à la carte via Wi‑Fi
3. Aller sur l’accueil
4. Lancer une course
5. Remonter un incident si besoin

---

## Problèmes fréquents

### “API_BASE_URL manquante”
- Le fichier `.env` n’est pas rempli.

### L’API ne répond pas
- Vérifier que le téléphone et le PC sont sur le même Wi‑Fi
- Tester dans le navigateur :
  ```
  http://IP_DU_PC:3001/api/health
  ```

### Les alertes ne s’affichent pas
- Vérifier que la remorque a des alertes côté API

---

## Explication des écrans
### Accueil
- Bouton “Lancer la course”
- Wi‑Fi & GPS en vert si OK, rouge sinon

### Incident
- Choix du type
- Gravité 1–10
- Localisation automatique
- Bouton “Envoyer le rapport”

### Alertes
- Liste des alertes maintenance
- Pastille rouge si non lues

### Tous les écrans
- Changement d'adresse IP pour la connexion à l'API si besoin (clic sur la pastille de connexion Internet en haut)

---

### Aide
La connexion et l'appairage à la carte électronique Renardo ('R-CO') reprend le travail réalisé par un groupe d'étudiants en 2025 :
- [Jana ZEBIAN](https://github.com/JanaZebian)
- [Jamil ACHEK](https://github.com/JamWare)
- [Ruben SAILLY](https://github.com/rubensailly)
- [Soufiane EZZEMANY](https://github.com/soufiane-ezzemany)
- [Manne E. KITSOUKOU](https://github.com/h00dieB0y)
- [Frédéric EGENSHEVILLER](https://github.com/frederic-egenscheviller)
