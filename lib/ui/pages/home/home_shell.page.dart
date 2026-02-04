import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadri_pilot/core/l10n/app_localizations.dart';
import 'package:quadri_pilot/logic/cubits/notifications.cubit.dart';
import 'package:quadri_pilot/logic/cubits/connection.cubit.dart' as tcp;
import 'package:quadri_pilot/logic/cubits/page.cubit.dart';
import 'package:quadri_pilot/data/models/connection_state.model.dart' as state;
import 'package:quadri_pilot/ui/widgets/wifi_connect_dialog.dart';

import 'home.page.dart';
import '../incident/incident_form.page.dart';
import '../notifications/notifications.page.dart';

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  int _currentIndex = 0;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    context.read<PageCubit>().navigateTo(AppPage.dashboard);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dialogShown) return;
      final connectionState = context.read<tcp.ConnectionCubit>().state;
      if (connectionState.status != state.ConnectionStatus.connected) {
        _dialogShown = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const WifiConnectDialog(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomePage(),
          IncidentFormPage(),
          NotificationsPage(),
        ],
      ),
      bottomNavigationBar: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final hasAlerts = state.unreadCount > 0;
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: theme.colorScheme.onSurfaceVariant,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: AppLocalizations.of(context).home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.report_gmailerrorred),
                label: AppLocalizations.of(context).incident,
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications),
                    if (hasAlerts)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                label: AppLocalizations.of(context).alerts,
              ),
            ],
          );
        },
      ),
    );
  }
}
