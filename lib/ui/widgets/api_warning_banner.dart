import 'package:flutter/material.dart';
import 'package:quadri_pilot/core/l10n/app_localizations.dart';

class ApiWarningBanner extends StatelessWidget {
  const ApiWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: theme.colorScheme.errorContainer,
        child: Text(
          l10n.apiMissingEnv,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onErrorContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
