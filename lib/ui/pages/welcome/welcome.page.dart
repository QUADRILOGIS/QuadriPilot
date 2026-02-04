import 'package:flutter/material.dart';
import 'package:quadri_pilot/constants/routes.dart';
import 'package:quadri_pilot/core/l10n/app_localizations.dart';
import 'widgets/animated_logo.widget.dart';
import 'widgets/animated_subtitle_text.widget.dart';
import 'widgets/animated_title_text.widget.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _logoOpacityAnimation;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _titleOpacityAnimation;
  late final Animation<Offset> _titleSlideAnimation;
  late final Animation<double> _subtitleOpacityAnimation;
  late final Animation<Offset> _subtitleSlideAnimation;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Routes.wifiScanner);
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo animations: fade in and scale up (from 0.0 to 0.5 of the animation)
    _logoOpacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );
    _logoScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    // Title text ("R-Co") animations: slide up and fade in (from 0.5 to 0.75)
    _titleOpacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 0.75, curve: Curves.easeIn),
    );
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.75, curve: Curves.easeOut),
      ),
    );

    // Subtitle text ("by Recardo") animations: slide up and fade in (from 0.75 to 1.0)
    _subtitleOpacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
    );
    _subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
      ),
    );

    // When the animation is complete, wait briefly and navigate.
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, Routes.wifiScanner);
        });
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor,
              theme.primaryColor.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedLogoWidget(
                opacityAnimation: _logoOpacityAnimation,
                scaleAnimation: _logoScaleAnimation,
              ),
              const SizedBox(height: 10),
              AnimatedTitleTextWidget(
                opacityAnimation: _titleOpacityAnimation,
                slideAnimation: _titleSlideAnimation,
              ),
              const SizedBox(height: 2),
              AnimatedSubtitleTextWidget(
                opacityAnimation: _subtitleOpacityAnimation,
                slideAnimation: _subtitleSlideAnimation,
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.wifiScanner);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppLocalizations.of(context).configureWifi),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
