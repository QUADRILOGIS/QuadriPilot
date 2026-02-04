import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quadri_pilot/constants/app_assets.dart';

class AppTitle extends StatelessWidget {
  final String title;

  const AppTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          AppAssets.logo,
          width: 22,
          height: 22,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }
}
