import 'package:flutter/material.dart';

import '../properties/card_settings.dart';

/// A wrapper widget that applies the visual transformations (position, scale, rotation, opacity)
/// from a [CardSettings] object to its child widget.
class CardStackSwiperItem extends StatelessWidget {
  const CardStackSwiperItem({
    super.key,
    required this.child,
    required this.settings,
  });

  /// The widget to which the transformations will be applied.
  final Widget child;

  /// The settings object containing the transformation values.
  final CardSettings settings;

  Matrix4 _computeTransform() {
    final Matrix4 matrix = Matrix4.identity();
    final double angle = settings.angle;
    final Offset? position = settings.position;
    final double? scale = settings.scale;

    if (position != null) {
      matrix.translateByDouble(position.dx, position.dy, 0, 1);
    }

    matrix.rotateZ(angle);

    if (scale != null) {
      matrix.scaleByDouble(scale, scale, scale, 1);
    }

    return matrix;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: settings.visibility,
      child: Transform(
        transform: _computeTransform(),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
