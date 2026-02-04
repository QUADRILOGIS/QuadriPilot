import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quadri_pilot/core/l10n/app_localizations.dart';

import 'package:quadri_pilot/constants/routes.dart';
import 'package:quadri_pilot/logic/cubits/page.cubit.dart';
import 'package:quadri_pilot/logic/cubits/locale.cubit.dart';
import 'package:quadri_pilot/logic/cubits/race.cubit.dart';
import 'package:quadri_pilot/logic/cubits/notifications.cubit.dart';
import 'package:quadri_pilot/logic/cubits/api_sync.cubit.dart';
import 'package:quadri_pilot/theme/theme.dart';
import 'package:quadri_pilot/theme/util.dart';
import 'package:quadri_pilot/ui/pages/home/home_shell.page.dart';
import 'package:quadri_pilot/ui/pages/splash/splash.page.dart';
import 'package:quadri_pilot/ui/pages/wifi_scanner/wifi_scanner.page.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:quadri_pilot/data/services/wifi_scan.service.dart';
import 'package:quadri_pilot/logic/cubits/sensors.cubit.dart';
import 'package:quadri_pilot/logic/cubits/connection.cubit.dart';
import 'package:quadri_pilot/logic/cubits/wifi_scan.cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();

    TextTheme textTheme = createTextTheme(context, "Raleway", "Raleway");
    MaterialTheme materialTheme = MaterialTheme(textTheme);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WiFiScanCubit(WiFiScanService())),
        BlocProvider(create: (context) => ConnectionCubit()),
        BlocProvider(create: (context) => SensorsCubit()),
        BlocProvider(create: (context) => PageCubit()),
        BlocProvider(
          create: (context) => RaceCubit(context.read<SensorsCubit>()),
        ),
        BlocProvider(
          create: (context) {
            final cubit = NotificationsCubit();
            cubit.start();
            return cubit;
          },
        ),
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(
          create: (context) {
            final cubit = ApiSyncCubit();
            cubit.start();
            return cubit;
          },
        ),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner : false,
            theme: materialTheme.light(),
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            title: 'QuadriPilot',
            home: const SplashPage(),
            routes: {
              Routes.wifiScanner: (context) => const WiFiScannerPage(),
              Routes.dashboard: (context) => const HomeShellPage(),
            },
          );
        },
      ),
    );
  }
}
