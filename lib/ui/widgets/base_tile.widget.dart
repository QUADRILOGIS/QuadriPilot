import 'package:flutter/material.dart';

/// A reusable tile widget that applies a common Card design:
/// - Fixed margin and elevation
/// - Rounded corners
/// - A gradient background
class BaseTile extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget child;
  final EdgeInsetsGeometry margin;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const BaseTile({
    super.key,
    required this.child,
    this.title,
    this.icon,
    this.margin = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    this.backgroundColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: margin,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: backgroundColor,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.primary, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      if (icon != null)
                        Icon(icon, color: theme.colorScheme.tertiary),
                      if (icon != null) const SizedBox(width: 8),
                      Text(
                        title!,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              child,
              // Dynamic sized spacer to fill the remaining space.],
            ],
          ),
        ),
      ),
    );
  }
}
