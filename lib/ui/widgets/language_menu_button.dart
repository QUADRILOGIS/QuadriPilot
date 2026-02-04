import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadri_pilot/logic/cubits/locale.cubit.dart';

class LanguageMenuButton extends StatelessWidget {
  const LanguageMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.language),
      onPressed: () async {
        final overlay = Overlay.of(context).context.findRenderObject();
        final box = context.findRenderObject() as RenderBox?;
        final position = box?.localToGlobal(Offset.zero) ?? Offset.zero;
        final size = box?.size ?? const Size(40, 40);

        final selected = await showMenu<Locale>(
          context: context,
          position: RelativeRect.fromRect(
            Rect.fromLTWH(position.dx, position.dy, size.width, size.height),
            Offset.zero & (overlay?.paintBounds.size ?? const Size(0, 0)),
          ),
          items: const [
            PopupMenuItem(value: Locale('fr'), child: Text('FR')),
            PopupMenuItem(value: Locale('en'), child: Text('EN')),
          ],
        );
        if (selected != null && context.mounted) {
          context.read<LocaleCubit>().setLocale(selected);
        }
      },
    );
  }
}
