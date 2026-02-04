import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'QuadriPilot'**
  String get appTitle;

  /// No description provided for @configureWifi.
  ///
  /// In en, this message translates to:
  /// **'Configure Wi-Fi'**
  String get configureWifi;

  /// No description provided for @availableDevices.
  ///
  /// In en, this message translates to:
  /// **'Available devices'**
  String get availableDevices;

  /// No description provided for @accessDashboard.
  ///
  /// In en, this message translates to:
  /// **'Access dashboard'**
  String get accessDashboard;

  /// No description provided for @connectToDevice.
  ///
  /// In en, this message translates to:
  /// **'Connect to device'**
  String get connectToDevice;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @connectingToDevice.
  ///
  /// In en, this message translates to:
  /// **'Connecting to device...'**
  String get connectingToDevice;

  /// No description provided for @connectedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Connected successfully!'**
  String get connectedSuccessfully;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionFailed;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @incident.
  ///
  /// In en, this message translates to:
  /// **'Incident'**
  String get incident;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @raceRunning.
  ///
  /// In en, this message translates to:
  /// **'Race in progress'**
  String get raceRunning;

  /// No description provided for @readyToStart.
  ///
  /// In en, this message translates to:
  /// **'Ready to start'**
  String get readyToStart;

  /// No description provided for @gpsPointsRecorded.
  ///
  /// In en, this message translates to:
  /// **'GPS points recorded: {count}'**
  String gpsPointsRecorded(Object count);

  /// No description provided for @stopRace.
  ///
  /// In en, this message translates to:
  /// **'Stop the race'**
  String get stopRace;

  /// No description provided for @startRace.
  ///
  /// In en, this message translates to:
  /// **'Start the race'**
  String get startRace;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @boardConnectionOk.
  ///
  /// In en, this message translates to:
  /// **'Board connection: OK'**
  String get boardConnectionOk;

  /// No description provided for @trailerStatus.
  ///
  /// In en, this message translates to:
  /// **'Trailer status: check'**
  String get trailerStatus;

  /// No description provided for @incidentTitle.
  ///
  /// In en, this message translates to:
  /// **'Incident report'**
  String get incidentTitle;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @incidentType.
  ///
  /// In en, this message translates to:
  /// **'Incident type'**
  String get incidentType;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @chooseType.
  ///
  /// In en, this message translates to:
  /// **'Please choose a type'**
  String get chooseType;

  /// No description provided for @incidentSent.
  ///
  /// In en, this message translates to:
  /// **'Incident sent (stub).'**
  String get incidentSent;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity (0-10)'**
  String get severity;

  /// No description provided for @material.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get material;

  /// No description provided for @obstacle.
  ///
  /// In en, this message translates to:
  /// **'Obstacle on the road'**
  String get obstacle;

  /// No description provided for @accident.
  ///
  /// In en, this message translates to:
  /// **'Accident'**
  String get accident;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get notifications;

  /// No description provided for @noAlerts.
  ///
  /// In en, this message translates to:
  /// **'No alerts'**
  String get noAlerts;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @mapPoints.
  ///
  /// In en, this message translates to:
  /// **'GPS track'**
  String get mapPoints;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @noWifiNetworks.
  ///
  /// In en, this message translates to:
  /// **'No Wi-Fi networks found'**
  String get noWifiNetworks;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// No description provided for @connectDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi connection required'**
  String get connectDialogTitle;

  /// No description provided for @connectDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Connect to the board Wi-Fi network to continue.'**
  String get connectDialogBody;

  /// No description provided for @connectDialogFooter.
  ///
  /// In en, this message translates to:
  /// **'Make sure the board is powered on'**
  String get connectDialogFooter;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get goHome;

  /// No description provided for @noGpsPoints.
  ///
  /// In en, this message translates to:
  /// **'No GPS points yet'**
  String get noGpsPoints;

  /// No description provided for @lastGpsPoint.
  ///
  /// In en, this message translates to:
  /// **'Last point: {lat}, {lng}'**
  String lastGpsPoint(Object lat, Object lng);

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// No description provided for @lastSeenMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String lastSeenMinutes(Object minutes);

  /// No description provided for @wifiLabel.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get wifiLabel;

  /// No description provided for @gpsLabel.
  ///
  /// In en, this message translates to:
  /// **'GPS'**
  String get gpsLabel;

  /// No description provided for @raceStoppedDuration.
  ///
  /// In en, this message translates to:
  /// **'Race stopped. Duration: {duration}'**
  String raceStoppedDuration(Object duration);

  /// No description provided for @raceStoppedWithLocation.
  ///
  /// In en, this message translates to:
  /// **'{message} · Last location {lat}, {lng}'**
  String raceStoppedWithLocation(String message, String lat, String lng);

  /// No description provided for @reportIncident.
  ///
  /// In en, this message translates to:
  /// **'Report an incident'**
  String get reportIncident;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select a type'**
  String get selectType;

  /// No description provided for @severityLabel.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severityLabel;

  /// No description provided for @severityBadge.
  ///
  /// In en, this message translates to:
  /// **'{label} ({value}/10)'**
  String severityBadge(Object label, Object value);

  /// No description provided for @severityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get severityLow;

  /// No description provided for @severityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get severityModerate;

  /// No description provided for @severityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get severityHigh;

  /// No description provided for @severityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get severityCritical;

  /// No description provided for @gpsPosition.
  ///
  /// In en, this message translates to:
  /// **'GPS position'**
  String get gpsPosition;

  /// No description provided for @fetchingLocation.
  ///
  /// In en, this message translates to:
  /// **'Fetching location...'**
  String get fetchingLocation;

  /// No description provided for @describeIncident.
  ///
  /// In en, this message translates to:
  /// **'Describe the incident in detail...'**
  String get describeIncident;

  /// No description provided for @sendReport.
  ///
  /// In en, this message translates to:
  /// **'Send report'**
  String get sendReport;

  /// No description provided for @sendingReport.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sendingReport;

  /// No description provided for @sendError.
  ///
  /// In en, this message translates to:
  /// **'Send failed'**
  String get sendError;

  /// No description provided for @sendDeferred.
  ///
  /// In en, this message translates to:
  /// **'Sent later'**
  String get sendDeferred;

  /// No description provided for @reportSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Report sent'**
  String get reportSentTitle;

  /// No description provided for @reportSentBody.
  ///
  /// In en, this message translates to:
  /// **'Your incident has been sent.'**
  String get reportSentBody;

  /// No description provided for @reportSentBodyOffline.
  ///
  /// In en, this message translates to:
  /// **'No Internet connection. Your report will be sent as soon as possible.'**
  String get reportSentBodyOffline;

  /// No description provided for @reportDeferredBadge.
  ///
  /// In en, this message translates to:
  /// **'Sent later'**
  String get reportDeferredBadge;

  /// No description provided for @syncOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get syncOnline;

  /// No description provided for @syncOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get syncOffline;

  /// No description provided for @syncPending.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String syncPending(int count);

  /// No description provided for @syncApiDown.
  ///
  /// In en, this message translates to:
  /// **'API unavailable'**
  String get syncApiDown;

  /// No description provided for @apiBaseUrlTitle.
  ///
  /// In en, this message translates to:
  /// **'API address'**
  String get apiBaseUrlTitle;

  /// No description provided for @apiBaseUrlHelp.
  ///
  /// In en, this message translates to:
  /// **'You can enter the base URL. Example: http://10.140.xxx.xxx:3001/api'**
  String get apiBaseUrlHelp;

  /// No description provided for @apiBaseUrlHint.
  ///
  /// In en, this message translates to:
  /// **'http://10.144.198.125:3001/api'**
  String get apiBaseUrlHint;

  /// No description provided for @apiTest.
  ///
  /// In en, this message translates to:
  /// **'Test API'**
  String get apiTest;

  /// No description provided for @apiTestOk.
  ///
  /// In en, this message translates to:
  /// **'API reachable'**
  String get apiTestOk;

  /// No description provided for @apiTestFailed.
  ///
  /// In en, this message translates to:
  /// **'API unreachable'**
  String get apiTestFailed;

  /// No description provided for @syncLastError.
  ///
  /// In en, this message translates to:
  /// **'Last error: {message}'**
  String syncLastError(String message);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @searchType.
  ///
  /// In en, this message translates to:
  /// **'Search a type'**
  String get searchType;

  /// No description provided for @incidentCategoryTrailer.
  ///
  /// In en, this message translates to:
  /// **'Trailer (mechanics / structure)'**
  String get incidentCategoryTrailer;

  /// No description provided for @incidentTrailerFlatTire.
  ///
  /// In en, this message translates to:
  /// **'Flat tire'**
  String get incidentTrailerFlatTire;

  /// No description provided for @incidentTrailerBrakeDefective.
  ///
  /// In en, this message translates to:
  /// **'Defective brake'**
  String get incidentTrailerBrakeDefective;

  /// No description provided for @incidentTrailerHitchDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged hitch'**
  String get incidentTrailerHitchDamaged;

  /// No description provided for @incidentTrailerChassis.
  ///
  /// In en, this message translates to:
  /// **'Structure / chassis'**
  String get incidentTrailerChassis;

  /// No description provided for @incidentTrailerUnstableLoad.
  ///
  /// In en, this message translates to:
  /// **'Unstable load / straps'**
  String get incidentTrailerUnstableLoad;

  /// No description provided for @incidentTrailerBearingNoise.
  ///
  /// In en, this message translates to:
  /// **'Bearing / abnormal noise'**
  String get incidentTrailerBearingNoise;

  /// No description provided for @incidentCategoryEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy / onboard electronics'**
  String get incidentCategoryEnergy;

  /// No description provided for @incidentEnergyBatteryLow.
  ///
  /// In en, this message translates to:
  /// **'Low battery'**
  String get incidentEnergyBatteryLow;

  /// No description provided for @incidentEnergyBatteryDead.
  ///
  /// In en, this message translates to:
  /// **'Battery dead'**
  String get incidentEnergyBatteryDead;

  /// No description provided for @incidentEnergyBeaconNoResponse.
  ///
  /// In en, this message translates to:
  /// **'Beacon not responding'**
  String get incidentEnergyBeaconNoResponse;

  /// No description provided for @incidentEnergyInconsistentData.
  ///
  /// In en, this message translates to:
  /// **'Inconsistent data (GPS/battery)'**
  String get incidentEnergyInconsistentData;

  /// No description provided for @incidentEnergyWifiDrop.
  ///
  /// In en, this message translates to:
  /// **'WiFi TCP/IP drop'**
  String get incidentEnergyWifiDrop;

  /// No description provided for @incidentCategorySoftware.
  ///
  /// In en, this message translates to:
  /// **'Software / application'**
  String get incidentCategorySoftware;

  /// No description provided for @incidentSoftwareAppBlocked.
  ///
  /// In en, this message translates to:
  /// **'App frozen'**
  String get incidentSoftwareAppBlocked;

  /// No description provided for @incidentSoftwareMissingData.
  ///
  /// In en, this message translates to:
  /// **'Missing data'**
  String get incidentSoftwareMissingData;

  /// No description provided for @incidentSoftwareRaceStartStop.
  ///
  /// In en, this message translates to:
  /// **'Race cannot start/stop'**
  String get incidentSoftwareRaceStartStop;

  /// No description provided for @incidentSoftwareSyncIssue.
  ///
  /// In en, this message translates to:
  /// **'Synchronization issue'**
  String get incidentSoftwareSyncIssue;

  /// No description provided for @incidentCategorySafety.
  ///
  /// In en, this message translates to:
  /// **'Safety / operations'**
  String get incidentCategorySafety;

  /// No description provided for @incidentSafetyAccident.
  ///
  /// In en, this message translates to:
  /// **'Trailer accident'**
  String get incidentSafetyAccident;

  /// No description provided for @incidentSafetyImmediateRisk.
  ///
  /// In en, this message translates to:
  /// **'Immediate safety risk'**
  String get incidentSafetyImmediateRisk;

  /// No description provided for @incidentSafetyStolen.
  ///
  /// In en, this message translates to:
  /// **'Trailer stolen / moved'**
  String get incidentSafetyStolen;

  /// No description provided for @incidentSafetyObstacle.
  ///
  /// In en, this message translates to:
  /// **'Obstacle preventing delivery'**
  String get incidentSafetyObstacle;

  /// No description provided for @incidentCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get incidentCategoryOther;

  /// No description provided for @incidentOther.
  ///
  /// In en, this message translates to:
  /// **'Other (specify)'**
  String get incidentOther;

  /// No description provided for @alertLabel.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alertLabel;

  /// No description provided for @warningLabel.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warningLabel;

  /// No description provided for @alertBodyCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical threshold reached'**
  String get alertBodyCritical;

  /// No description provided for @alertBodyWarning.
  ///
  /// In en, this message translates to:
  /// **'Maintenance required.'**
  String get alertBodyWarning;

  /// No description provided for @readLabel.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get readLabel;

  /// No description provided for @relativeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{value} min ago'**
  String relativeMinutes(Object value);

  /// No description provided for @relativeHours.
  ///
  /// In en, this message translates to:
  /// **'{value} h ago'**
  String relativeHours(Object value);

  /// No description provided for @relativeDays.
  ///
  /// In en, this message translates to:
  /// **'{value} days ago'**
  String relativeDays(Object value);

  /// No description provided for @unreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String unreadCount(Object count);

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get filterAlerts;

  /// No description provided for @filterWarnings.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get filterWarnings;

  /// No description provided for @filterRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get filterRead;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @yesterdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterdayLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
