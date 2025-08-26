# Card Stack Swiper

[![Pub Version](https://img.shields.io/pub/v/card_stack_swiper?logo=dart&logoColor=white)](https://pub.dev/packages/card_stack_swiper)
[![Pub Points](https://badgen.net/pub/points/card_stack_swiper)](https://pub.dev/packages/card_stack_swiper)
[![Pub Likes](https://badgen.net/pub/likes/card_stack_swiper)](https://pub.dev/packages/card_stack_swiper)

This is a Flutter package for a Stack card swiper. ✨

It allows you to swipe left, right, up, and down and define your own business logic for each direction. It features smooth animations and supports Android, iOS.

## Why?

We built this package because we wanted to:

-   Have a fully customizable slider
-   Swipe in any direction
-   Undo swipes as many times as you want
-   Choose your own settings such as duration, angle, offsets and more
-   Trigger swipes programmatically with a controller
-   Add callbacks for swipe, undo, on end, or when the swiper is disabled
-   Detect the real-time swipe direction

## Show Cases

| Swipe in any direction                                                                                                             | Programmatic Swipes | Undo a Swipe |
|------------------------------------------------------------------------------------------------------------------------------------| :------------- | :---------------- |
| <img src="https://github.com/Politanskyi/card_stack_swiper/blob/master/images/swipe_in_any_direction.gif?raw=true" height="275" /> | <img src="https://github.com/Politanskyi/card_stack_swiper/blob/master/images/trigger_swipes.gif?raw=true" height="275" /> | <img src="https://github.com/Politanskyi/card_stack_swiper/blob/master/images/unswipe_the_cards.gif?raw=true" height="275" /> 

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  card_stack_swiper: ^1.0.2
```

**OR** run this command in your project's root directory:

```bash
flutter pub add card_stack_swiper
```

## Usage

Here is a basic example of how to use the `CardStackSwiper`.

```dart
import 'package:flutter/material.dart';
import 'package:card_stack_swiper/card_stack_swiper.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final CardStackSwiperController _controller = CardStackSwiperController();

  final List<Widget> _cards = [
    for (int i = 0; i < 10; i++)
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.primaries[i % Colors.primaries.length].shade300,
        child: Center(child: Text('Card ${i + 1}', style: const TextStyle(fontSize: 24, color: Colors.white))),
      )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CardStackSwiper Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 400,
              width: 300,
              child: CardStackSwiper(
                controller: _controller,
                cardsCount: _cards.length,
                initialIndex: 0,
                isLoop: true,
                onSwipe: (previousIndex, currentIndex, direction) {
                  debugPrint('Swiped from $previousIndex to $currentIndex in $direction direction');
                  return true;
                },
                onEnd: () {
                  debugPrint('Reached end of the stack');
                },
                cardBuilder: (context, index, horizontalPercentage, verticalPercentage) {
                  return _cards[index];
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: _controller.undo,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _controller.swipe(CardStackSwiperDirection.right),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
```

## Constructor Parameters

| Parameter                           | Default                       | Description                                                                                                   | Required |
| ----------------------------------- |:------------------------------| :------------------------------------------------------------------------------------------------------------ | :------: |
| `cardBuilder`                       | -                             | A builder function that creates a widget for a given card index.                                              |   Yes    |
| `cardsCount`                        | -                             | The total number of cards in the stack.                                                                       |   Yes    |
| `controller`                        | -                             | The controller used to programmatically control the swiper.                                                   |    No    |
| `initialIndex`                      | `0`                           | The index of the card to display initially.                                                                   |    No    |
| `isDisabled`                        | `false`                       | If `true`, swiping by user gesture is disabled.                                                               |    No    |
| `onTapDisabled`                     | -                             | Callback function that is called when the swiper is tapped while disabled.                                    |    No    |
| `onPressed`                         | -                             | Callback function that is called when a card is tapped.                                                       |    No    |
| `onSwipe`                           | -                             | A callback to validate a swipe action. The swipe is cancelled if it returns `false`.                          |    No    |
| `onUndo`                            | -                             | A callback to validate an undo action. The action is cancelled if it returns `false`.                         |    No    |
| `onSwipeDirectionChange`            | -                             | A callback that is triggered in real-time as the user drags a card.                                           |    No    |
| `onEnd`                             | -                             | A callback that is executed when the last card in a non-looping stack is swiped.                              |    No    |
| `isLoop`                            | `true`                        | Whether the stack should loop after the last card.                                                            |    No    |
| `maxAngle`                          | `20`                          | The maximum angle the card reaches while swiping, in degrees.                                                 |    No    |
| `threshold`                         | `30`                          | The percentage of the screen width from which the card is swiped away.                                        |    No    |
| `backCardOffset`                    | `Offset(60, 0)`               | The offset of the back cards from the front card.                                                             |    No    |
| `backCardAngle`                     | `0.1`                         | The angle of the back cards, in radians.                                                                      |    No    |
| `backCardScale`                     | `0.8`                         | The scale of the back cards.                                                                                  |    No    |
| `allowedSwipeDirection`             | `AllowedSwipeDirection.all()` | Defines the directions in which the card is allowed to be swiped.                                             |    No    |
| `swipeAnimationDuration`            | `Duration(milliseconds: 300)` | The duration of the swipe animation.                                                                          |    No    |
| `returnAnimationDuration`           | `Duration(milliseconds: 400)` | The duration of the animation when a card returns to the center.                                              |    No    |
| `verticalSwipeThresholdMultiplier`  | `0.8`                         | A multiplier to adjust the sensitivity of the vertical swipe.                                                 |    No    |

## Controller API

The `CardStackSwiperController` allows you to control the widget programmatically.

| Method   | Description                                     |
| -------- | :---------------------------------------------- |
| `swipe`  | Swipes the card to a specific direction.        |
| `undo`   | Brings back the last card that was swiped away. |
| `moveTo` | Changes the top card to a specific index.       |

<hr/>

## Credits

-   **Mike Politanskyi** (Package Maintainer)