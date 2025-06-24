import 'package:flutter/material.dart';
import 'package:card_stack_swiper/card_stack_swiper.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExamplePage(),
    ),
  );
}

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
        child: Center(
          child: Text(
            'Card ${i + 1}',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      )
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Stack Swiper Example'),
      ),
      body: SafeArea(
        child: Center(
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
                  cardBuilder: (context, index, horizontalPercentage, verticalPercentage) => _cards[index],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 'undo',
                    onPressed: _controller.undo,
                    child: const Icon(Icons.rotate_left),
                  ),
                  FloatingActionButton(
                    heroTag: 'left',
                    onPressed: () => _controller.swipe(CardStackSwiperDirection.left),
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  FloatingActionButton(
                    heroTag: 'right',
                    onPressed: () => _controller.swipe(CardStackSwiperDirection.right),
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
