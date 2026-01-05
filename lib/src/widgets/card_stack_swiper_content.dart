import 'package:card_stack_swiper/card_stack_swiper.dart';
import 'package:flutter/material.dart';

class CardStackSwiperContent extends StatelessWidget {
  const CardStackSwiperContent({
    super.key,
    required this.emptyCardBuilder,
    required this.shouldShowEmptyCard,
    required this.cardStackBuilder,
  });

  final CardStackSwiperEmptyCardBuilder? emptyCardBuilder;
  final bool shouldShowEmptyCard;
  final Widget Function(BoxConstraints) cardStackBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: switch (emptyCardBuilder) {
            final CardStackSwiperEmptyCardBuilder builder?
                when shouldShowEmptyCard =>
              KeyedSubtree(
                key: const ValueKey('empty_card'),
                child: builder(context),
              ),
            _ => KeyedSubtree(
                key: const ValueKey('card_stack'),
                child: cardStackBuilder(constraints),
              ),
          },
        );
      },
    );
  }
}
