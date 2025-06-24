import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../controller/card_stack_swiper_controller.dart';
import '../controller/controller_event.dart';
import '../enums.dart';
import '../properties/allowed_swipe_direction.dart';
import '../properties/card_settings.dart';
import '../typedefs.dart';
import '../utils/card_animation.dart';
import '../utils/undoable.dart';
import 'card_stack_swiper_item.dart';

part 'card_stack_swiper_slider_state.dart';

/// A widget for creating a swipeable stack of cards, similar to a Tinder-style interface.
///
/// It allows you to swipe cards in multiple directions and define custom logic
/// for each action. Features smooth animations and is highly customizable.
class CardStackSwiper extends StatefulWidget {
  const CardStackSwiper({
    super.key,
    required this.cardBuilder,
    required this.cardsCount,
    this.controller,
    this.initialIndex = 0,
    this.isDisabled = false,
    this.onTapDisabled,
    this.onPressed,
    this.onSwipe,
    this.onUndo,
    this.onSwipeDirectionChange,
    this.onEnd,
    this.isLoop = true,
    this.maxAngle = 20,
    this.threshold = 30,
    this.backCardOffset = const Offset(60, 0),
    this.backCardAngle = 0.1,
    this.backCardScale = 0.8,
    this.allowedSwipeDirection = const AllowedSwipeDirection.all(),
    this.swipeAnimationDuration = const Duration(milliseconds: 300),
    this.returnAnimationDuration = const Duration(milliseconds: 400),
    this.verticalSwipeThresholdMultiplier = 0.8,
  }) : assert(
          cardsCount == 0 || (initialIndex >= 0 && initialIndex < cardsCount),
          'initialIndex must be within the bounds of cardsCount',
        );

  /// Function that builds each card in the stack.
  /// The function is called with the build context and the index of the card to be built.
  /// It should return a widget that represents the card.
  final CardStackSwiperBuilder cardBuilder;

  /// The total number of cards in the stack.
  final int cardsCount;

  /// The controller used to programmatically control the swiper.
  /// If `null`, the swiper can only be controlled by user gestures.
  final CardStackSwiperController? controller;

  /// The index of the card to display initially.
  /// Defaults to 0.
  final int initialIndex;

  /// Whether swiping is disabled.
  /// If `true`, swiping by user gesture is disabled, except when triggered by the [controller].
  final bool isDisabled;

  /// Callback function that is called when the swiper is tapped while disabled.
  final CardStackSwiperOnTapDisabled? onTapDisabled;

  /// A boolean that determines whether the card stack should loop.
  /// When the last card is swiped, if `isLoop` is true, the stack resets to the first card.
  /// Defaults to `false`.
  final bool isLoop;

  /// Callback function that is called when a card is tapped.
  /// The function is called with the index of the tapped card.
  final ValueChanged<int>? onPressed;

  /// Callback function that is called when a swipe action is performed.
  /// The function is called with the previous and current card indices and the direction of the swipe.
  /// If the function returns `false`, the swipe action is canceled.
  final CardStackSwiperOnSwipe? onSwipe;

  /// Callback function that is called when an undo action is performed.
  /// The function is called with the old and new card indices and the direction of the swipe being undone.
  /// If the function returns `false`, the undo action is canceled.
  final CardStackSwiperOnUndo? onUndo;

  /// Callback function that is called when the swipe direction changes.
  /// The function is called with the last detected horizontal and vertical directions.
  final CardStackSwiperDirectionChange? onSwipeDirectionChange;

  /// Callback function that is called when there are no more cards to swipe.
  final CardStackSwiperOnEnd? onEnd;

  /// The maximum angle the card reaches while swiping, in degrees.
  /// Defaults to 20 degrees.
  final double maxAngle;

  /// The percentage of the screen width from which the card is swiped away.
  /// Must be between 1 and 100. Defaults to 30.
  final int threshold;

  /// The offset of the back cards from the front card.
  /// Defaults to `Offset(60, 0)`.
  final Offset backCardOffset;

  /// The angle of the back cards, in radians.
  /// Defaults to 0.1.
  final double backCardAngle;

  /// The scale of the back cards.
  /// Must be between 0 and 1. Defaults to 0.8.
  final double backCardScale;

  /// Defines the directions in which the card is allowed to be swiped.
  /// Defaults to [AllowedSwipeDirection.all].
  final AllowedSwipeDirection allowedSwipeDirection;

  /// The duration of the swipe animation.
  /// Defaults to 300 milliseconds.
  final Duration swipeAnimationDuration;

  /// The duration of the animation when a card returns to the center.
  /// This animation is triggered when a drag is released before the threshold is met.
  /// Defaults to 400 milliseconds.
  final Duration returnAnimationDuration;

  /// A multiplier to adjust the sensitivity of the vertical swipe.
  /// A smaller value makes the vertical swipe more sensitive. Defaults to 0.8.
  final double verticalSwipeThresholdMultiplier;

  @override
  State<CardStackSwiper> createState() => _CardStackSwiperState();
}
