import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quadri_pilot/constants/app_config.dart';
import 'package:quadri_pilot/core/l10n/app_localizations.dart';
import 'package:quadri_pilot/data/services/incident_api.service.dart';
import 'package:quadri_pilot/data/services/incident_queue.service.dart';
import 'package:quadri_pilot/data/models/sensors.model.dart';
import 'package:quadri_pilot/data/services/api_config.service.dart';
import 'package:quadri_pilot/logic/cubits/sensors.cubit.dart';
import 'package:quadri_pilot/ui/widgets/app_title.widget.dart';
import 'package:quadri_pilot/ui/widgets/language_menu_button.dart';
import 'package:quadri_pilot/ui/widgets/sync_status_chip.dart';
import 'package:url_launcher/url_launcher.dart';

class IncidentFormPage extends StatefulWidget {
  const IncidentFormPage({super.key});

  @override
  State<IncidentFormPage> createState() => _IncidentFormPageState();
}

class _IncidentFormPageState extends State<IncidentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();
  final _incidentApi = IncidentApiService();
  final _incidentQueue = IncidentQueueService();
  final _config = ApiConfigService();

  String? _selectedType;
  String? _selectedTypeValue;
  bool _typeError = false;
  double _severity = 5;
  bool _loadingLocation = false;
  bool _isSending = false;
  bool _showSuccess = false;
  bool _sentOffline = false;
  String? _gpsText;
  double? _gpsLat;
  double? _gpsLng;
  DateTime? _lastCardGpsAt;
  StreamSubscription? _gpsSubscription;
  Timer? _phoneGpsTimer;
  String _managerPhone = '';

  @override
  void initState() {
    super.initState();
    _fillCurrentLocation();
    _listenCardGps();
    _startPhoneGpsTimer();
    _loadManagerPhone();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _searchController.dispose();
    _gpsSubscription?.cancel();
    _phoneGpsTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadManagerPhone() async {
    final phone = await _config.getManagerPhone();
    if (mounted) {
      setState(() => _managerPhone = phone);
    } else {
      _managerPhone = phone;
    }
  }

  Future<void> _fillCurrentLocation() async {
    setState(() => _loadingLocation = true);
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      _setGps(position.latitude, position.longitude);
    } finally {
      if (mounted) {
        setState(() => _loadingLocation = false);
      }
    }
  }

  void _setGps(double lat, double lng) {
    _gpsLat = lat;
    _gpsLng = lng;
    final latText = '${lat.abs().toStringAsFixed(4)}° ${lat >= 0 ? 'N' : 'S'}';
    final lngText = '${lng.abs().toStringAsFixed(4)}° ${lng >= 0 ? 'E' : 'W'}';
    if (mounted) {
      setState(() {
        _gpsText = '$latText  ,  $lngText';
      });
    } else {
      _gpsText = '$latText  ,  $lngText';
    }
  }

  void _listenCardGps() {
    final sensorsCubit = context.read<SensorsCubit>();
    _gpsSubscription = sensorsCubit.stream.listen((stateMap) {
      final gpsData = stateMap[SENSORS.GPS_S];
      if (gpsData == null) return;
      final gps = gpsData.gps;
      if (gps == null) return;
      final (lat, lng) = gps;
      if (lat.isNaN || lng.isNaN) return;
      _lastCardGpsAt = DateTime.now();
      _setGps(lat, lng);
    });
  }

  void _startPhoneGpsTimer() {
    _phoneGpsTimer?.cancel();
    _phoneGpsTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (_lastCardGpsAt != null &&
          DateTime.now().difference(_lastCardGpsAt!) <
              const Duration(seconds: 10)) {
        return;
      }
      await _fillCurrentLocation();
    });
  }

  void _submit() {
    final hasType = _selectedType != null && _selectedTypeValue != null;
    setState(() => _typeError = !hasType);
    if (!hasType) return;
    if (!_formKey.currentState!.validate()) return;
    _sendWithFeedback();
  }

  Future<void> _sendWithFeedback() async {
    setState(() => _isSending = true);
    final l10n = AppLocalizations.of(context);
    final payload = IncidentPayload(
      message: _buildMessage(),
      trailerId: AppConfig.trailerId,
      seriousness: _severity.round(),
      incidentType: _selectedTypeValue!,
      latitude: _gpsLat,
      longitude: _gpsLng,
    );
    try {
      await _incidentApi.postIncident(payload);
      _sentOffline = false;
    } on IncidentApiException catch (error) {
      await _incidentQueue.enqueue(payload);
      _sentOffline = true;
      if (mounted) {
        final detail = error.message.isNotEmpty ? ' ${error.message}' : '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${l10n.sendDeferred} (${error.statusCode})$detail'),
          ),
        );
      }
    } catch (_) {
      await _incidentQueue.enqueue(payload);
      _sentOffline = true;
    }
    if (!mounted) return;
    setState(() {
      _isSending = false;
      _selectedType = null;
      _selectedTypeValue = null;
      _typeError = false;
      _severity = 5;
      _descriptionController.clear();
      _showSuccess = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _showSuccess = false);
  }

  String _buildMessage() {
    final description = _descriptionController.text.trim();
    final label = _selectedType ?? 'Incident';
    String message;
    if (description.isNotEmpty) {
      if (description.length >= 10) {
        message = description;
      } else {
        message = '$label : $description';
      }
    } else if (label.length >= 10) {
      message = label;
    } else {
      message = 'Incident: $label';
    }
    if (message.length > 1000) {
      return message.substring(0, 1000);
    }
    return message;
  }

  List<_IncidentTypeItem> _buildIncidentTypes(AppLocalizations l10n) {
    return [
      _IncidentTypeItem.header(l10n.incidentCategoryTrailer),
      _IncidentTypeItem.item(l10n.incidentTrailerFlatTire, 'pneu_creve'),
      _IncidentTypeItem.item(
          l10n.incidentTrailerBrakeDefective, 'frein_defectueux'),
      _IncidentTypeItem.item(
          l10n.incidentTrailerHitchDamaged, 'attelage_endommage'),
      _IncidentTypeItem.item(
          l10n.incidentTrailerChassis, 'structure_chassis'),
      _IncidentTypeItem.item(
          l10n.incidentTrailerUnstableLoad, 'charge_instable'),
      _IncidentTypeItem.item(
          l10n.incidentTrailerBearingNoise, 'roulement_bruit_anormal'),
      _IncidentTypeItem.header(l10n.incidentCategoryEnergy),
      _IncidentTypeItem.item(
          l10n.incidentEnergyBatteryLow, 'batterie_faible'),
      _IncidentTypeItem.item(
          l10n.incidentEnergyBatteryDead, 'batterie_hs'),
      _IncidentTypeItem.item(
          l10n.incidentEnergyBeaconNoResponse, 'balise_ne_repond_plus'),
      _IncidentTypeItem.item(
          l10n.incidentEnergyInconsistentData, 'donnees_incoherentes'),
      _IncidentTypeItem.item(
          l10n.incidentEnergyWifiDrop, 'coupure_wifi_tcp'),
      _IncidentTypeItem.header(l10n.incidentCategorySoftware),
      _IncidentTypeItem.item(
          l10n.incidentSoftwareAppBlocked, 'application_bloquee'),
      _IncidentTypeItem.item(
          l10n.incidentSoftwareMissingData, 'donnees_manquantes'),
      _IncidentTypeItem.item(
          l10n.incidentSoftwareRaceStartStop, 'course_impossible'),
      _IncidentTypeItem.item(
          l10n.incidentSoftwareSyncIssue, 'probleme_synchronisation'),
      _IncidentTypeItem.header(l10n.incidentCategorySafety),
      _IncidentTypeItem.item(
          l10n.incidentSafetyAccident, 'remorque_accidentee'),
      _IncidentTypeItem.item(
          l10n.incidentSafetyImmediateRisk, 'risque_securite_immediat'),
      _IncidentTypeItem.item(
          l10n.incidentSafetyStolen, 'remorque_volee_deplacee'),
      _IncidentTypeItem.item(
          l10n.incidentSafetyObstacle, 'obstacle_livraison'),
      _IncidentTypeItem.header(l10n.incidentCategoryOther),
      _IncidentTypeItem.item(l10n.incidentOther, 'autre'),
    ];
  }

  Future<void> _openTypePicker(AppLocalizations l10n) async {
    final items = _buildIncidentTypes(l10n);
    _searchController.clear();
    final selected = await showModalBottomSheet<_IncidentTypeItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final query = _searchController.text.toLowerCase();
            final filtered = _filterItems(items, query);
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: l10n.searchType,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (_) => setModalState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        if (item.isHeader) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 6),
                            child: Text(
                              item.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          );
                        }
                        final isSelected = item.label == _selectedType;
                        return InkWell(
                          onTap: () => Navigator.pop(context, item),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedType = selected.label;
        _selectedTypeValue = selected.value;
        _typeError = false;
      });
    }
  }

  List<_IncidentTypeItem> _filterItems(
    List<_IncidentTypeItem> items,
    String query,
  ) {
    if (query.isEmpty) return items;
    final List<_IncidentTypeItem> filtered = [];
    String? currentHeader;
    List<_IncidentTypeItem> buffer = [];

    for (final item in items) {
      if (item.isHeader) {
        if (buffer.isNotEmpty && currentHeader != null) {
          filtered.add(_IncidentTypeItem.header(currentHeader));
          filtered.addAll(buffer);
          buffer = [];
        }
        currentHeader = item.label;
      } else if (item.label.toLowerCase().contains(query)) {
        buffer.add(item);
      }
    }

    if (buffer.isNotEmpty && currentHeader != null) {
      filtered.add(_IncidentTypeItem.header(currentHeader));
      filtered.addAll(buffer);
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: AppTitle(title: l10n.appTitle),
        actions: const [LanguageMenuButton()],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  20 + MediaQuery.of(context).viewInsets.bottom,
                ),
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: SyncStatusChip(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.reportIncident,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.incidentType,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _openTypePicker(l10n),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _typeError
                              ? theme.colorScheme.error
                              : theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedType ?? l10n.selectType,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _selectedType == null
                                    ? theme.colorScheme.onSurfaceVariant
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const Icon(Icons.expand_more),
                        ],
                      ),
                    ),
                  ),
                  if (_typeError) ...[
                    const SizedBox(height: 6),
                    Text(
                      l10n.chooseType,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.severityLabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _severityColor().withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.severityBadge(
                            _severityLabel(l10n),
                            _severity.round(),
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _severityColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1', style: theme.textTheme.bodySmall),
                      Text('5', style: theme.textTheme.bodySmall),
                      Text('10', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF3DB547),
                                Color(0xFFF59E0B),
                                Color(0xFFEF4444),
                              ],
                            ),
                          ),
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 6,
                            activeTrackColor: Colors.transparent,
                            inactiveTrackColor: Colors.transparent,
                            thumbColor: Colors.white,
                            overlayShape:
                                const RoundSliderOverlayShape(overlayRadius: 0),
                            trackShape: const RectangularSliderTrackShape(),
                          ),
                          child: Slider(
                            value: _severity,
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: _severity.round().toString(),
                            onChanged: (value) =>
                                setState(() => _severity = value),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.gpsPosition,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _gpsText ?? l10n.fetchingLocation,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        if (_loadingLocation)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 6,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: l10n.describeIncident,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isSending ? null : _submit,
                    icon: _isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    label: Text(
                      _isSending ? l10n.sendingReport : l10n.sendReport,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.managerContact,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.phone,
                                color: theme.colorScheme.primary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _managerPhone.isEmpty
                                    ? l10n.managerPhonePlaceholder
                                    : _managerPhone,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: _managerPhone.isEmpty
                                      ? theme.colorScheme.onSurfaceVariant
                                      : theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: _editManagerPhone,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed:
                                _managerPhone.isEmpty ? null : _callManager,
                            icon: const Icon(Icons.call, size: 18),
                            label: Text(l10n.callManager),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            if (_showSuccess)
              _SuccessOverlay(
                l10n: l10n,
                sentOffline: _sentOffline,
              ),
          ],
        ),
      ),
    );
  }

  String _severityLabel(AppLocalizations l10n) {
    if (_severity >= 8) return l10n.severityCritical;
    if (_severity >= 6) return l10n.severityHigh;
    if (_severity >= 3) return l10n.severityModerate;
    return l10n.severityLow;
  }

  Color _severityColor() {
    if (_severity >= 8) return const Color(0xFFEF4444);
    if (_severity >= 6) return const Color(0xFFF59E0B);
    if (_severity >= 3) return const Color(0xFFFB923C);
    return const Color(0xFF3DB547);
  }

  Future<void> _editManagerPhone() async {
    final controller = TextEditingController(text: _managerPhone);
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.editManagerPhone),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: l10n.managerPhonePlaceholder,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final value = controller.text.trim();
                await _config.setManagerPhone(value);
                if (mounted) {
                  setState(() => _managerPhone = value);
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  Future<void> _callManager() async {
    if (_managerPhone.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: _managerPhone);
    await launchUrl(uri);
  }
}

class _IncidentTypeItem {
  final String label;
  final bool isHeader;
  final String? value;

  const _IncidentTypeItem._(this.label, this.isHeader, this.value);

  factory _IncidentTypeItem.header(String label) =>
      _IncidentTypeItem._(label, true, null);
  factory _IncidentTypeItem.item(String label, String value) =>
      _IncidentTypeItem._(label, false, value);
}

class _SuccessOverlay extends StatelessWidget {
  final AppLocalizations l10n;
  final bool sentOffline;

  const _SuccessOverlay({required this.l10n, required this.sentOffline});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check,
                  color: theme.colorScheme.primary, size: 44),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.reportSentTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sentOffline ? l10n.reportSentBodyOffline : l10n.reportSentBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (sentOffline) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  l10n.reportDeferredBadge,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
