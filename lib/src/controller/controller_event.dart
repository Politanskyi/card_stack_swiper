import '../enums.dart';

/// A sealed class representing all possible events that can be sent to the [CardStackSwiperController].
sealed class ControllerEvent {
  const ControllerEvent();
}

/// An event that triggers a swipe in a specific direction.
class ControllerSwipeEvent extends ControllerEvent {
  const ControllerSwipeEvent(this.direction);

  /// The direction of the swipe.
  final CardStackSwiperDirection direction;
}

/// An event that triggers an undo of the last swipe.
class ControllerUndoEvent extends ControllerEvent {
  const ControllerUndoEvent();
}

/// An event that moves the swiper to a specific card index.
class ControllerMoveEvent extends ControllerEvent {
  const ControllerMoveEvent(this.index);

  /// The target index to move to.
  final int index;
}
