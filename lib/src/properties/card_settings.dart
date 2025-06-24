import 'dart:ui';

/// A data class that holds the visual properties of a card in the stack.
class CardSettings {
  /// Creates a new instance of card settings.
  const CardSettings({this.angle = 0, this.position, this.scale, this.visibility = 1, this.draggable = false});

  /// The rotation angle of the card in radians.
  final double angle;

  /// The positional offset of the card.
  final Offset? position;

  /// The scale transformation of the card.
  final double? scale;

  /// The opacity of the card, from 0.0 to 1.0.
  final double visibility;

  /// Whether the card is currently draggable.
  final bool draggable;

  /// Linearly interpolates between two [CardSettings] objects.
  static CardSettings? lerp(CardSettings? a, CardSettings? b, double t) {
    if (a == null || b == null) return null;

    return CardSettings(
      position: Offset.lerp(a.position, b.position, t),
      angle: lerpDouble(a.angle, b.angle, t) ?? 0,
      scale: lerpDouble(a.scale, b.scale, t),
      visibility: lerpDouble(a.visibility, b.visibility, t) ?? 0,
      draggable: a.draggable,
    );
  }
}
