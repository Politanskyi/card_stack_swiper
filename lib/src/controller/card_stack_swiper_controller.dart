import 'dart:async';
import '../enums.dart';
import 'controller_event.dart';

/// A controller that can be used to trigger actions on a [CardStackSwiper] widget.
class CardStackSwiperController {
  final _eventController = StreamController<ControllerEvent>.broadcast();

  /// A stream of controller events.
  /// The [CardStackSwiper] widget listens to this stream to perform actions.
  Stream<ControllerEvent> get events => _eventController.stream;

  /// Triggers a swipe in the specified [direction].
  void swipe(CardStackSwiperDirection direction) {
    _eventController.add(ControllerSwipeEvent(direction));
  }

  /// Reverts the last swipe action.
  void undo() {
    _eventController.add(const ControllerUndoEvent());
  }

  /// Moves the stack to a specific card [index].
  void moveTo(int index) {
    _eventController.add(ControllerMoveEvent(index));
  }

  /// Disposes the controller and closes the event stream.
  Future<void> dispose() async {
    await _eventController.close();
  }
}
