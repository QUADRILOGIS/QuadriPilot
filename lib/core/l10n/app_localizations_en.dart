// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'QuadriPilot';

  @override
  String get configureWifi => 'Configure Wi-Fi';

  @override
  String get availableDevices => 'Available devices';

  @override
  String get accessDashboard => 'Access dashboard';

  @override
  String get connectToDevice => 'Connect to device';

  @override
  String get refresh => 'Refresh';

  @override
  String get connectingToDevice => 'Connecting to device...';

  @override
  String get connectedSuccessfully => 'Connected successfully!';

  @override
  String get connectionFailed => 'Connection failed';

  @override
  String get tryAgain => 'Try again';

  @override
  String get home => 'Home';

  @override
  String get incident => 'Incident';

  @override
  String get alerts => 'Alerts';

  @override
  String get raceRunning => 'Race in progress';

  @override
  String get readyToStart => 'Ready to start';

  @override
  String gpsPointsRecorded(Object count) {
    return 'GPS points recorded: $count';
  }

  @override
  String get stopRace => 'Stop the race';

  @override
  String get startRace => 'Start the race';

  @override
  String get summary => 'Summary';

  @override
  String get boardConnectionOk => 'Board connection: OK';

  @override
  String get trailerStatus => 'Trailer status: check';

  @override
  String get incidentTitle => 'Incident report';

  @override
  String get title => 'Title';

  @override
  String get incidentType => 'Incident type';

  @override
  String get location => 'Location';

  @override
  String get description => 'Description';

  @override
  String get send => 'Send';

  @override
  String get requiredField => 'Required field';

  @override
  String get chooseType => 'Please choose a type';

  @override
  String get incidentSent => 'Incident sent (stub).';

  @override
  String get severity => 'Severity (0-10)';

  @override
  String get material => 'Equipment';

  @override
  String get obstacle => 'Obstacle on the road';

  @override
  String get accident => 'Accident';

  @override
  String get other => 'Other';

  @override
  String get notifications => 'Alerts';

  @override
  String get noAlerts => 'No alerts';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get mapPoints => 'GPS track';

  @override
  String get language => 'Language';

  @override
  String get noWifiNetworks => 'No Wi-Fi networks found';

  @override
  String get connected => 'Connected';

  @override
  String get notConnected => 'Not connected';

  @override
  String get connectDialogTitle => 'Wi-Fi connection required';

  @override
  String get connectDialogBody =>
      'Connect to the board Wi-Fi network to continue.';

  @override
  String get connectDialogFooter => 'Make sure the board is powered on';

  @override
  String get goHome => 'Go to home';

  @override
  String get noGpsPoints => 'No GPS points yet';

  @override
  String lastGpsPoint(Object lat, Object lng) {
    return 'Last point: $lat, $lng';
  }

  @override
  String get battery => 'Battery';

  @override
  String lastSeenMinutes(Object minutes) {
    return '$minutes min ago';
  }

  @override
  String get wifiLabel => 'WiFi';

  @override
  String get gpsLabel => 'GPS';

  @override
  String raceStoppedDuration(Object duration) {
    return 'Race stopped. Duration: $duration';
  }

  @override
  String raceStoppedWithLocation(String message, String lat, String lng) {
    return '$message · Last location $lat, $lng';
  }

  @override
  String get reportIncident => 'Report an incident';

  @override
  String get selectType => 'Select a type';

  @override
  String get severityLabel => 'Severity';

  @override
  String severityBadge(Object label, Object value) {
    return '$label ($value/10)';
  }

  @override
  String get severityLow => 'Low';

  @override
  String get severityModerate => 'Moderate';

  @override
  String get severityHigh => 'High';

  @override
  String get severityCritical => 'Critical';

  @override
  String get gpsPosition => 'GPS position';

  @override
  String get fetchingLocation => 'Fetching location...';

  @override
  String get describeIncident => 'Describe the incident in detail...';

  @override
  String get sendReport => 'Send report';

  @override
  String get sendingReport => 'Sending...';

  @override
  String get sendError => 'Send failed';

  @override
  String get sendDeferred => 'Sent later';

  @override
  String get reportSentTitle => 'Report sent';

  @override
  String get reportSentBody => 'Your incident has been sent.';

  @override
  String get reportSentBodyOffline =>
      'No Internet connection. Your report will be sent as soon as possible.';

  @override
  String get reportDeferredBadge => 'Sent later';

  @override
  String get syncOnline => 'Online';

  @override
  String get syncOffline => 'Offline';

  @override
  String syncPending(int count) {
    return '$count pending';
  }

  @override
  String get syncApiDown => 'API unavailable';

  @override
  String get apiBaseUrlTitle => 'API address';

  @override
  String get apiBaseUrlHelp =>
      'You can enter the base URL. Example: http://10.140.xxx.xxx:3001/api';

  @override
  String get apiBaseUrlHint => 'http://10.144.198.125:3001/api';

  @override
  String get apiTest => 'Test API';

  @override
  String get apiTestOk => 'API reachable';

  @override
  String get apiTestFailed => 'API unreachable';

  @override
  String syncLastError(String message) {
    return 'Last error: $message';
  }

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get searchType => 'Search a type';

  @override
  String get incidentCategoryTrailer => 'Trailer (mechanics / structure)';

  @override
  String get incidentTrailerFlatTire => 'Flat tire';

  @override
  String get incidentTrailerBrakeDefective => 'Defective brake';

  @override
  String get incidentTrailerHitchDamaged => 'Damaged hitch';

  @override
  String get incidentTrailerChassis => 'Structure / chassis';

  @override
  String get incidentTrailerUnstableLoad => 'Unstable load / straps';

  @override
  String get incidentTrailerBearingNoise => 'Bearing / abnormal noise';

  @override
  String get incidentCategoryEnergy => 'Energy / onboard electronics';

  @override
  String get incidentEnergyBatteryLow => 'Low battery';

  @override
  String get incidentEnergyBatteryDead => 'Battery dead';

  @override
  String get incidentEnergyBeaconNoResponse => 'Beacon not responding';

  @override
  String get incidentEnergyInconsistentData =>
      'Inconsistent data (GPS/battery)';

  @override
  String get incidentEnergyWifiDrop => 'WiFi TCP/IP drop';

  @override
  String get incidentCategorySoftware => 'Software / application';

  @override
  String get incidentSoftwareAppBlocked => 'App frozen';

  @override
  String get incidentSoftwareMissingData => 'Missing data';

  @override
  String get incidentSoftwareRaceStartStop => 'Race cannot start/stop';

  @override
  String get incidentSoftwareSyncIssue => 'Synchronization issue';

  @override
  String get incidentCategorySafety => 'Safety / operations';

  @override
  String get incidentSafetyAccident => 'Trailer accident';

  @override
  String get incidentSafetyImmediateRisk => 'Immediate safety risk';

  @override
  String get incidentSafetyStolen => 'Trailer stolen / moved';

  @override
  String get incidentSafetyObstacle => 'Obstacle preventing delivery';

  @override
  String get incidentCategoryOther => 'Other';

  @override
  String get incidentOther => 'Other (specify)';

  @override
  String get alertLabel => 'Alert';

  @override
  String get warningLabel => 'Warning';

  @override
  String get alertBodyCritical => 'Critical threshold reached';

  @override
  String get alertBodyWarning => 'Maintenance required.';

  @override
  String get readLabel => 'Read';

  @override
  String relativeMinutes(Object value) {
    return '$value min ago';
  }

  @override
  String relativeHours(Object value) {
    return '$value h ago';
  }

  @override
  String relativeDays(Object value) {
    return '$value days ago';
  }

  @override
  String unreadCount(Object count) {
    return '$count unread';
  }

  @override
  String get filterAll => 'All';

  @override
  String get filterAlerts => 'Alerts';

  @override
  String get filterWarnings => 'Warnings';

  @override
  String get filterRead => 'Read';

  @override
  String get todayLabel => 'Today';

  @override
  String get yesterdayLabel => 'Yesterday';
}
