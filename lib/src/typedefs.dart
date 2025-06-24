import 'dart:async';

import 'package:flutter/widgets.dart';

import 'enums.dart';

/// A builder function that creates a widget for a given card index.
/// The [context], [index], [horizontalOffsetPercentage], and [verticalOffsetPercentage]
/// are passed to the builder. It can return a `Widget` or `null` to display an empty card.
typedef CardStackSwiperBuilder =
    Widget? Function(BuildContext context, int index, int horizontalOffsetPercentage, int verticalOffsetPercentage);

/// A callback that is triggered in real-time as the user drags a card.
/// It provides the current inferred [horizontal] and [vertical] swipe directions.
typedef CardStackSwiperDirectionChange =
    void Function(CardStackSwiperDirection horizontal, CardStackSwiperDirection vertical);

/// A callback that is executed when a user taps on the swiper while it is disabled.
typedef CardStackSwiperOnTapDisabled = FutureOr<void> Function();

/// A callback to validate a swipe action.
/// It is called before a swipe animation begins. The swipe is cancelled if it returns `false`.
/// The [previousIndex] is the index of the card being swiped, and [currentIndex]
/// is the index of the card that will become the new top card.
typedef CardStackSwiperOnSwipe =
    FutureOr<bool> Function(int previousIndex, int? currentIndex, CardStackSwiperDirection direction);

/// A callback to validate an undo action.
/// It is called before an undo action is performed. The action is cancelled if it returns `false`.
/// The [previousIndex] is the index of the card that was on top before the undo,
/// and [currentIndex] is the index being returned to.
typedef CardStackSwiperOnUndo = bool Function(int? previousIndex, int currentIndex, CardStackSwiperDirection direction);

/// A callback that is executed when the last card in a non-looping stack is swiped.
typedef CardStackSwiperOnEnd = FutureOr<void> Function();
