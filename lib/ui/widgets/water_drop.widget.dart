import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Parameters for a single water drop.
class WaterDropParam {
  final double top;
  final double left;
  final double width;
  final double height;

  const WaterDropParam({
    required this.top,
    required this.left,
    required this.width,
    required this.height,
  });
}

/// A widget that overlays one or more water drops on top of a child widget.
class WaterDrop extends StatelessWidget {
  final List<WaterDropParam> params;
  final Widget child;

  const WaterDrop({
    super.key,
    required this.params,
    required this.child,
  });

  /// Convenience factory for a single drop.
  factory WaterDrop.single({
    Key? key,
    required double left,
    required double top,
    required double width,
    required double height,
    required Widget child,
  }) {
    return WaterDrop(
      key: key,
      params: [
        WaterDropParam(top: top, left: left, width: width, height: height),
      ],
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        ...params.map((param) => _WaterDrop(
              left: param.left,
              top: param.top,
              width: param.width,
              height: param.height,
              child: child,
            )),
      ],
    );
  }
}

/// Internal widget that builds a single water drop.
/// Box shadows have been removed and the drop is more translucent.
class _WaterDrop extends StatefulWidget {
  final double top;
  final double left;
  final double width;
  final double height;
  final Widget child;

  const _WaterDrop({
    required this.child,
    required this.top,
    required this.width,
    required this.left,
    required this.height,
  });

  @override
  __WaterDropState createState() => __WaterDropState();
}

class __WaterDropState extends State<_WaterDrop> {
  Size? totalSize;

  @override
  Widget build(BuildContext context) {
    // On first build, capture the parent widget’s size.
    if (totalSize == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            totalSize = context.size;
          });
        }
      });
    }

    // Use captured size or fallback to the screen size.
    final Size size = totalSize ?? MediaQuery.of(context).size;
    final Alignment alignment = _getAlignment(size);
    final Alignment alignmentModifier = Alignment(
      widget.width / size.width,
      widget.height / size.height,
    );

    // Wrap the drop’s content in an Opacity widget for translucency.
    Widget childWithGradient = Opacity(
      opacity: 0.3, // Adjust this value for more or less translucency.
      child: Container(
        foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: alignment - alignmentModifier,
            end: alignment + alignmentModifier,
            colors: [
              Colors.black.withValues(alpha: 0.3),
              Colors.white.withValues(alpha: 0.3),
            ],
          ),
          backgroundBlendMode: BlendMode.overlay,
        ),
        child: widget.child,
      ),
    );

    return IgnorePointer(
      child: Stack(
        children: <Widget>[
          // The drop shadow widget (_OvalShadow) has been removed.
          ...List.generate(8, (i) {
            return Transform.scale(
              scale: 1 + 0.02 * i,
              alignment: alignment,
              child: ClipPath(
                // Use the custom teardrop clipper.
                clipper: WaterDropClipper(
                  center: center,
                  width: widget.width * (1 - 0.04 * i),
                  height: widget.height * (1 - 0.04 * i),
                ),
                clipBehavior: Clip.hardEdge,
                child: childWithGradient,
              ),
            );
          }),
          _LightDot(
            width: widget.width,
            height: widget.height,
            top: widget.top,
            left: widget.left,
          ),
        ],
      ),
    );
  }

  /// Returns the center point of the drop.
  Offset get center => Offset(
        widget.left + widget.width / 2,
        widget.top + widget.height / 2,
      );

  /// Maps the drop’s center to an Alignment.
  Alignment _getAlignment(Size size) => Alignment(
        (center.dx - size.width / 2) / (size.width / 2),
        (center.dy - size.height / 2) / (size.height / 2),
      );
}

/// A custom clipper that creates a teardrop (water drop) shape.
class WaterDropClipper extends CustomClipper<Path> {
  final Offset center;
  final double width;
  final double height;

  WaterDropClipper({
    required this.center,
    required this.width,
    required this.height,
  });

  @override
  Path getClip(Size size) {
    final double left = center.dx - width / 2;
    final double top = center.dy - height / 2;

    final Path path = Path();
    // Start at the top center.
    path.moveTo(center.dx, top);
    // Curve from the top to the right edge.
    path.quadraticBezierTo(
      left + width,
      top + height * 0.35,
      left + width * 0.85,
      top + height * 0.75,
    );
    // Curve to the bottom center (the drop’s tip).
    path.quadraticBezierTo(
      center.dx,
      top + height,
      left + width * 0.15,
      top + height * 0.75,
    );
    // Curve from the left edge back to the top center.
    path.quadraticBezierTo(
      left,
      top + height * 0.35,
      center.dx,
      top,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

/// A light dot rendered on top of the drop to simulate a reflection.
/// Its box shadow has been removed for a cleaner, flat highlight.
class _LightDot extends StatelessWidget {
  final double top;
  final double left;
  final double width;
  final double height;

  const _LightDot({
    required this.top,
    required this.left,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left + width / 4,
      top: top + height / 4,
      width: width / 4,
      height: height / 4,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Instead of a box shadow, use a flat translucent fill.
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
