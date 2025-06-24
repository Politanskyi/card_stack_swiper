import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../enums.dart';
import '../properties/allowed_swipe_direction.dart';

/// A helper class to manage the card's animation state, including its
/// position, angle, and progress during various animations.
class CardAnimation {
  CardAnimation({
    required this.controller,
    required this.maxAngle,
    this.onSwipeDirectionChanged,
  });

  /// The animation controller that drives all animations.
  final AnimationController controller;

  /// The maximum angle the card can rotate during a drag.
  final double maxAngle;

  /// A callback that is triggered when the swipe direction changes during a drag.
  final void Function(CardStackSwiperDirection direction)? onSwipeDirectionChanged;

  /// The current pixel offset of the card from the center due to dragging.
  Offset dragPosition = Offset.zero;

  /// The current rotation angle of the card in radians.
  double dragAngle = 0;

  /// The progress of the current swipe or undo animation, from 0.0 to 1.0.
  double animationProgress = 0;

  double get _maxAngleInRadian => maxAngle * (math.pi / 180);

  /// Calculates the permitted drag delta based on the allowed directions.
  Offset _getPermittedDelta(
    DragUpdateDetails details,
    AllowedSwipeDirection allowedDirection,
  ) {
    double dx = 0;
    double dy = 0;

    final bool isMovingLeft = details.delta.dx < 0;
    final bool isMovingRight = details.delta.dx > 0;
    final bool isMovingUp = details.delta.dy < 0;
    final bool isMovingDown = details.delta.dy > 0;

    // As you correctly pointed out, we can combine the conditions.
    // If movement is allowed left AND the user moves left, OR
    // if movement is allowed right AND the user moves right, then we apply the horizontal delta.
    if ((allowedDirection.left && isMovingLeft) || (allowedDirection.right && isMovingRight)) {
      dx = details.delta.dx;
    }

    // Same logic for the vertical axis.
    if ((allowedDirection.up && isMovingUp) || (allowedDirection.down && isMovingDown)) {
      dy = details.delta.dy;
    }

    return Offset(dx, dy);
  }

  /// Updates the drag position and angle based on the user's gesture.
  void updateDrag({
    required BuildContext context,
    required DragUpdateDetails details,
    required AllowedSwipeDirection allowedDirection,
  }) {
    final Offset delta = _getPermittedDelta(details, allowedDirection);

    if (delta == Offset.zero) return;

    dragPosition += delta;
    dragAngle = (_maxAngleInRadian * dragPosition.dx / (MediaQuery.sizeOf(context).width / 2)).clamp(
      -_maxAngleInRadian,
      _maxAngleInRadian,
    );

    if (delta.dx.abs() > delta.dy.abs()) {
      onSwipeDirectionChanged?.call(delta.dx > 0 ? CardStackSwiperDirection.right : CardStackSwiperDirection.left);
    } else if (delta.dy.abs() > delta.dx.abs()) {
      onSwipeDirectionChanged?.call(delta.dy > 0 ? CardStackSwiperDirection.bottom : CardStackSwiperDirection.top);
    }
  }

  /// Starts an animation to swipe the card off-screen.
  Future<void> swipe({
    required BuildContext context,
    required CardStackSwiperDirection direction,
    required Duration duration,
  }) async {
    controller.duration = duration;

    final Size screenSize = MediaQuery.sizeOf(context);

    final Offset endPosition = switch (direction) {
      CardStackSwiperDirection.left => Offset(-screenSize.width * 1.2, dragPosition.dy * 2),
      CardStackSwiperDirection.right => Offset(screenSize.width * 1.2, dragPosition.dy * 2),
      CardStackSwiperDirection.top => Offset(dragPosition.dx * 2, -screenSize.height),
      CardStackSwiperDirection.bottom => Offset(dragPosition.dx * 2, screenSize.height),
      CardStackSwiperDirection.none => Offset.zero,
    };

    final Animation<double> swipeAnimation = controller.drive(
      CurveTween(curve: Curves.easeIn),
    );

    final Animation<Offset> positionAnimation = Tween<Offset>(
      begin: dragPosition,
      end: endPosition,
    ).animate(swipeAnimation);

    final Animation<double> progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(swipeAnimation);

    void animationListener() {
      dragPosition = positionAnimation.value;
      animationProgress = progressAnimation.value;
    }

    controller.addListener(animationListener);

    return controller.forward(from: 0).whenComplete(() {
      controller.removeListener(animationListener);
      controller.reset();
      reset();
    });
  }

  /// Starts an animation to bring a previously swiped card back onto the stack.
  Future<void> undo({
    required BuildContext context,
    required CardStackSwiperDirection direction,
    required Duration duration,
  }) async {
    final Size screenSize = MediaQuery.sizeOf(context);

    final Offset startPosition = switch (direction) {
      CardStackSwiperDirection.left => Offset(-screenSize.width, 0),
      CardStackSwiperDirection.right => Offset(screenSize.width, 0),
      CardStackSwiperDirection.top => Offset(0, -screenSize.height),
      CardStackSwiperDirection.bottom => Offset(0, screenSize.height),
      CardStackSwiperDirection.none => Offset.zero,
    };

    final Animation<double> undoAnimation = controller.drive(CurveTween(curve: Curves.easeOut));

    final Animation<Offset> positionAnimation = Tween<Offset>(
      begin: startPosition,
      end: Offset.zero,
    ).animate(undoAnimation);

    final Animation<double> progressAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(undoAnimation);

    void animationListener() {
      dragPosition = positionAnimation.value;
      animationProgress = progressAnimation.value;
      dragAngle = 0;
    }

    controller.addListener(animationListener);

    return controller.forward(from: 0).whenComplete(() {
      controller.removeListener(animationListener);
      controller.reset();
      reset();
    });
  }

  /// Starts an animation to return the card to the center of the stack.
  /// Used when a drag is released before the swipe threshold is met.
  Future<void> animateBackToCenter({required BuildContext context, required Duration duration}) async {
    controller.duration = duration;

    final Animation<double> returnAnimation = controller.drive(CurveTween(curve: Curves.easeOut));
    final Animation<Offset> positionAnimation = Tween<Offset>(
      begin: dragPosition,
      end: Offset.zero,
    ).animate(returnAnimation);

    final Animation<double> angleAnimation = Tween<double>(
      begin: dragAngle,
      end: 0,
    ).animate(returnAnimation);

    void animationListener() {
      dragPosition = positionAnimation.value;
      dragAngle = angleAnimation.value;
    }

    controller.addListener(animationListener);

    return controller.forward(from: 0).whenComplete(() {
      controller.removeListener(animationListener);
      controller.reset();
      reset();
    });
  }

  /// Resets all animation properties to their initial state.
  void reset() {
    dragPosition = Offset.zero;
    dragAngle = 0;
    animationProgress = 0;
    onSwipeDirectionChanged?.call(CardStackSwiperDirection.none);
  }
}
