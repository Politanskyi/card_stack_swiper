/// Defines the direction of a swipe action.
enum CardStackSwiperDirection {
  /// No swipe direction is detected.
  none,

  /// Swipe direction is to the left.
  left,

  /// Swipe direction is to the right.
  right,

  /// Swipe direction is to the top.
  top,

  /// Swipe direction is to the bottom.
  bottom,
}

/// Represents the visual status of a card in the stack, used for animations.
enum CardStackSwiperStatus {
  /// The card is at the top of the stack.
  top,

  /// The card is in the 'start' position in the background stack.
  start,

  /// The card is in the 'end' position in the background stack.
  end,

  /// The card is not visible.
  invisible,
}
