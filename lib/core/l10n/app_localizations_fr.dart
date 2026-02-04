// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'QuadriPilot';

  @override
  String get configureWifi => 'Configurer la Wi-Fi';

  @override
  String get availableDevices => 'Appareils disponibles';

  @override
  String get accessDashboard => 'Accéder à l\'accueil';

  @override
  String get connectToDevice => 'Se connecter à la carte';

  @override
  String get refresh => 'Rafraîchir';

  @override
  String get connectingToDevice => 'Connexion à la carte...';

  @override
  String get connectedSuccessfully => 'Connexion réussie !';

  @override
  String get connectionFailed => 'Échec de connexion';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get home => 'Accueil';

  @override
  String get incident => 'Incident';

  @override
  String get alerts => 'Alertes';

  @override
  String get raceRunning => 'Course en cours';

  @override
  String get readyToStart => 'Prêt à partir';

  @override
  String gpsPointsRecorded(Object count) {
    return 'Points GPS enregistrés : $count';
  }

  @override
  String get stopRace => 'Arrêter la course';

  @override
  String get startRace => 'Lancer la course';

  @override
  String get summary => 'Résumé';

  @override
  String get boardConnectionOk => 'Connexion à la carte : OK';

  @override
  String get trailerStatus => 'État remorque : à surveiller';

  @override
  String get incidentTitle => 'Remontée d\'incident';

  @override
  String get title => 'Titre';

  @override
  String get incidentType => 'Type d\'incident';

  @override
  String get location => 'Lieu';

  @override
  String get description => 'Description';

  @override
  String get send => 'Envoyer';

  @override
  String get requiredField => 'Champ requis';

  @override
  String get chooseType => 'Veuillez choisir un type';

  @override
  String get incidentSent => 'Incident envoyé (stub).';

  @override
  String get severity => 'Gravité (0-10)';

  @override
  String get material => 'Matériel';

  @override
  String get obstacle => 'Obstacle sur la route';

  @override
  String get accident => 'Accident';

  @override
  String get other => 'Autre';

  @override
  String get notifications => 'Alertes';

  @override
  String get noAlerts => 'Aucune alerte';

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get mapPoints => 'Trace GPS';

  @override
  String get language => 'Langue';

  @override
  String get noWifiNetworks => 'Aucun réseau Wi-Fi trouvé';

  @override
  String get connected => 'Connecté';

  @override
  String get notConnected => 'Non connecté';

  @override
  String get connectDialogTitle => 'Connexion Wi-Fi requise';

  @override
  String get connectDialogBody =>
      'Connectez-vous au réseau Wi-Fi de la carte électronique pour continuer.';

  @override
  String get connectDialogFooter =>
      'Assurez-vous que la carte électronique est allumée';

  @override
  String get goHome => 'Aller à l\'accueil';

  @override
  String get noGpsPoints => 'Aucun point GPS pour le moment';

  @override
  String lastGpsPoint(Object lat, Object lng) {
    return 'Dernier point : $lat, $lng';
  }

  @override
  String get battery => 'Batterie';

  @override
  String lastSeenMinutes(Object minutes) {
    return 'il y a $minutes min';
  }

  @override
  String get wifiLabel => 'WiFi';

  @override
  String get gpsLabel => 'GPS';

  @override
  String raceStoppedDuration(Object duration) {
    return 'Course arrêtée. Durée : $duration';
  }

  @override
  String raceStoppedWithLocation(String message, String lat, String lng) {
    return '$message · Dernière position $lat, $lng';
  }

  @override
  String get reportIncident => 'Signaler un incident';

  @override
  String get selectType => 'Sélectionner un type';

  @override
  String get severityLabel => 'Gravité';

  @override
  String severityBadge(Object label, Object value) {
    return '$label ($value/10)';
  }

  @override
  String get severityLow => 'Faible';

  @override
  String get severityModerate => 'Modérée';

  @override
  String get severityHigh => 'Élevé';

  @override
  String get severityCritical => 'Critique';

  @override
  String get gpsPosition => 'Position GPS';

  @override
  String get fetchingLocation => 'Localisation en cours...';

  @override
  String get describeIncident => 'Décrivez l\'incident en détail...';

  @override
  String get sendReport => 'Envoyer le rapport';

  @override
  String get sendingReport => 'Envoi en cours...';

  @override
  String get sendError => 'Erreur lors de l\'envoi';

  @override
  String get sendDeferred => 'Envoyé en différé';

  @override
  String get reportSentTitle => 'Rapport envoyé';

  @override
  String get reportSentBody => 'Votre incident a été transmis.';

  @override
  String get reportSentBodyOffline =>
      'Pas de connexion Internet. Votre incident sera envoyé dès que possible.';

  @override
  String get reportDeferredBadge => 'Envoyé en différé';

  @override
  String get syncOnline => 'En ligne';

  @override
  String get syncOffline => 'Hors ligne';

  @override
  String syncPending(int count) {
    return '$count en attente';
  }

  @override
  String get syncApiDown => 'API indisponible';

  @override
  String get apiBaseUrlTitle => 'Adresse API';

  @override
  String get apiBaseUrlHelp =>
      'Vous pouvez entrer l\'URL de base. Exemple : http://10.140.xxx.xxx:3001/api';

  @override
  String get apiBaseUrlHint => 'http://10.144.198.125:3001/api';

  @override
  String get apiTest => 'Tester l\'API';

  @override
  String get apiTestOk => 'API accessible';

  @override
  String get apiTestFailed => 'API inaccessible';

  @override
  String syncLastError(String message) {
    return 'Dernière erreur : $message';
  }

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get searchType => 'Rechercher un type';

  @override
  String get incidentCategoryTrailer => 'Remorque (mécanique / structure)';

  @override
  String get incidentTrailerFlatTire => 'Pneu crevé';

  @override
  String get incidentTrailerBrakeDefective => 'Frein défectueux';

  @override
  String get incidentTrailerHitchDamaged => 'Attelage endommagé';

  @override
  String get incidentTrailerChassis => 'Structure / châssis';

  @override
  String get incidentTrailerUnstableLoad => 'Charge instable / sangles';

  @override
  String get incidentTrailerBearingNoise => 'Roulement / bruit anormal';

  @override
  String get incidentCategoryEnergy => 'Énergie / électronique embarquée';

  @override
  String get incidentEnergyBatteryLow => 'Batterie faible';

  @override
  String get incidentEnergyBatteryDead => 'Batterie HS';

  @override
  String get incidentEnergyBeaconNoResponse => 'Balise ne répond plus';

  @override
  String get incidentEnergyInconsistentData =>
      'Données incohérentes (GPS/batterie)';

  @override
  String get incidentEnergyWifiDrop => 'Coupure WiFi';

  @override
  String get incidentCategorySoftware => 'Logiciel / application';

  @override
  String get incidentSoftwareAppBlocked => 'Application bloquée';

  @override
  String get incidentSoftwareMissingData => 'Données manquantes';

  @override
  String get incidentSoftwareRaceStartStop =>
      'Course impossible à lancer/arrêter';

  @override
  String get incidentSoftwareSyncIssue => 'Problème de synchronisation';

  @override
  String get incidentCategorySafety => 'Sécurité / exploitation';

  @override
  String get incidentSafetyAccident => 'Remorque accidentée';

  @override
  String get incidentSafetyImmediateRisk => 'Risque sécurité immédiat';

  @override
  String get incidentSafetyStolen => 'Remorque volée / déplacée';

  @override
  String get incidentSafetyObstacle => 'Obstacle empêchant la livraison';

  @override
  String get incidentCategoryOther => 'Autre';

  @override
  String get incidentOther => 'Autre (à préciser)';

  @override
  String get alertLabel => 'Alerte';

  @override
  String get warningLabel => 'Attention';

  @override
  String get alertBodyCritical => 'Seuil critique atteint';

  @override
  String get alertBodyWarning => 'Prévoir maintenance.';

  @override
  String get readLabel => 'Lu';

  @override
  String relativeMinutes(Object value) {
    return 'il y a $value min';
  }

  @override
  String relativeHours(Object value) {
    return 'il y a $value h';
  }

  @override
  String relativeDays(Object value) {
    return 'il y a $value jours';
  }

  @override
  String unreadCount(Object count) {
    return '$count non lues';
  }

  @override
  String get filterAll => 'Toutes';

  @override
  String get filterAlerts => 'Alertes';

  @override
  String get filterWarnings => 'Avertissements';

  @override
  String get filterRead => 'Lues';

  @override
  String get todayLabel => 'Aujourd\'hui';

  @override
  String get yesterdayLabel => 'Hier';
}
