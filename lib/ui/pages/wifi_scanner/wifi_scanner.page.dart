import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadri_pilot/core/l10n/app_localizations.dart';
import 'package:quadri_pilot/data/enum/default_values.enum.dart';
import 'package:quadri_pilot/logic/cubits/page.cubit.dart';
import 'package:quadri_pilot/ui/widgets/app_title.widget.dart';
import 'package:quadri_pilot/ui/widgets/language_menu_button.dart';
import 'package:quadri_pilot/ui/widgets/sync_status_chip.dart';
import '../../../constants/routes.dart';
import '../../../data/models/connection_state.model.dart' as state;
import '../../../data/models/wifi_network.model.dart';
import '../../../data/services/tcp_exchanges/tcp_client.service.dart';
import '../../../logic/cubits/sensors.cubit.dart';
import '../../../logic/cubits/connection.cubit.dart' as tcp;
import '../../../logic/cubits/wifi_scan.cubit.dart';
import 'widgets/wifi_list.widget.dart';

class WiFiScannerPage extends StatefulWidget {
  const WiFiScannerPage({super.key});

  @override
  State<WiFiScannerPage> createState() => _WiFiScannerPageState();
}

class _WiFiScannerPageState extends State<WiFiScannerPage> {
  @override
  void initState() {
    super.initState();
    context.read<WiFiScanCubit>().startConnectionCheck();

    Future.microtask(() {
      if (mounted) {
        context.read<WiFiScanCubit>().scanWiFiNetworks();
      }
    });
  }

  @override
  void dispose() {
    context.read<WiFiScanCubit>().stopConnectionCheck();
    super.dispose();
  }

  Future<void> _refresh() async {
    await context.read<WiFiScanCubit>().scanWiFiNetworks();
  }

  Future<void> _launchTcpConnection() async {
    // **Show the loader popup while connecting**
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildConnectionPopup(),
    );

    final tcpService = TcpClientService(
      host: DefaultValues.IP,
      port: DefaultValues.PORT,
      connectionCubit: context.read<tcp.ConnectionCubit>(),
      sensorsCubit: context.read<SensorsCubit>(),
      pageCubit: context.read<PageCubit>(),
    );

    await tcpService.connect();
    final isConnected = tcpService.isConnected;

    // **Wait before showing success/failure animation**
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context); // Close the loading popup
      _showConnectionResult(isConnected);
    });
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
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refresh,
            child: BlocBuilder<WiFiScanCubit, List<WiFiNetwork>>(
              builder: (context, wifiList) {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SyncStatusChip(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.availableDevices,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(child: WiFiListWidget()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          BlocBuilder<tcp.ConnectionCubit, state.ConnectionState>(
        builder: (context, connectionState) {
          bool isWiFiConnected = context.watch<WiFiScanCubit>().isConnected;
          return BottomNavigationBar(
            items: [
              isWiFiConnected
                  ? BottomNavigationBarItem(
                      icon: connectionState.status ==
                              state.ConnectionStatus.connected
                          ? Icon(Icons.arrow_forward)
                          : Icon(Icons.leak_add),
                      label: connectionState.status ==
                              state.ConnectionStatus.connected
                          ? l10n.accessDashboard
                          : l10n.connectToDevice,
                      backgroundColor: const Color(0xFF141414),
                    )
                  : BottomNavigationBarItem(icon: Container(), label: ''),
              BottomNavigationBarItem(
                icon: Icon(Icons.refresh),
                label: l10n.refresh,
                backgroundColor: const Color(0xFF141414),
              ),
            ],
            onTap: (index) async {
              if (index == 1) {
                await _refresh();
              } else if (index == 0) {
                if (connectionState.status ==
                    state.ConnectionStatus.connected) {
                  Navigator.pushReplacementNamed(context, Routes.dashboard);
                  context.read<PageCubit>().navigateTo(AppPage.dashboard);
                } else {
                  await _launchTcpConnection();
                }
              }
            },
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: theme.colorScheme.onSurfaceVariant,
            selectedLabelStyle:
                TextStyle(color: theme.colorScheme.primary),
            unselectedLabelStyle:
                TextStyle(color: theme.colorScheme.onSurfaceVariant),
          );
        },
      ),
    );
  }

  /// **Show Loader Popup**
  Widget _buildConnectionPopup() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.connectingToDevice,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Show Connection Result Popup**
  void _showConnectionResult(bool success) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Icon(
                  success ? Icons.check_circle : Icons.cancel,
                  key: ValueKey<bool>(success),
                  color: Theme.of(context).colorScheme.primary,
                  size: 80,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                success ? AppLocalizations.of(context).connectedSuccessfully : AppLocalizations.of(context).connectionFailed,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close popup
                  if (success) {
                    Navigator.pushReplacementNamed(context, Routes.dashboard);
                    context.read<PageCubit>().navigateTo(AppPage.dashboard);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  success
                      ? AppLocalizations.of(context).accessDashboard
                      : AppLocalizations.of(context).tryAgain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
