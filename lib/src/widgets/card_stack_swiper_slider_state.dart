part of 'card_stack_swiper.dart';

class _CardStackSwiperState extends State<CardStackSwiper> with TickerProviderStateMixin {
  final Queue<CardStackSwiperDirection> _directionHistory = Queue();

  late final Map<CardStackSwiperStatus, CardSettings> _sliderSettings;
  late final CardAnimation _sliderAnimation;

  late AnimationController _animationController;
  late Undoable<int?> _undoableIndex;

  StreamSubscription<ControllerEvent>? _controllerSubscription;

  CardStackSwiperDirection _detectedHorizontalDirection = CardStackSwiperDirection.none;
  CardStackSwiperDirection _detectedVerticalDirection = CardStackSwiperDirection.none;

  int? get _currentIndex => _undoableIndex.state;
  int get _cardsCount => widget.cardsCount;
  bool get _canSwipe => _currentIndex != null && !widget.isDisabled;

  @override
  void initState() {
    _updateSliderSettings();

    _undoableIndex = Undoable(widget.initialIndex);

    _animationController = AnimationController(vsync: this);

    _sliderAnimation = CardAnimation(
      controller: _animationController,
      maxAngle: widget.maxAngle,
      onSwipeDirectionChanged: _onSwipeDirectionChanged,
    );

    _controllerSubscription = widget.controller?.events.listen(_onControllerEvent);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant CardStackSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.backCardScale != oldWidget.backCardScale ||
        widget.backCardAngle != oldWidget.backCardAngle ||
        widget.backCardOffset != oldWidget.backCardOffset) {
      _updateSliderSettings();
      setState(() {});
    }

    if (widget.cardsCount != oldWidget.cardsCount) {
      if (_currentIndex != null && _currentIndex! >= widget.cardsCount) {
        setState(() {
          _undoableIndex = Undoable(widget.initialIndex);
          _directionHistory.clear();
          _sliderAnimation.reset();
        });
      }
    }
  }

  void _updateSliderSettings() {
    _sliderSettings = {
      CardStackSwiperStatus.invisible: CardSettings(scale: widget.backCardScale - 0.1, visibility: 0),
      CardStackSwiperStatus.start: CardSettings(
        angle: widget.backCardAngle,
        position: widget.backCardOffset,
        scale: widget.backCardScale,
        visibility: 1,
      ),
      CardStackSwiperStatus.end: CardSettings(
        angle: -widget.backCardAngle,
        position: Offset(-widget.backCardOffset.dx, widget.backCardOffset.dy),
        scale: widget.backCardScale,
        visibility: 1,
      ),
      CardStackSwiperStatus.top: const CardSettings(
        angle: 0,
        position: Offset.zero,
        scale: 1,
        visibility: 1,
        draggable: true,
      ),
    };
  }

  void _onControllerEvent(ControllerEvent event) {
    return switch (event) {
      ControllerSwipeEvent(:final direction) => _swipe(direction),
      ControllerUndoEvent() => _undo(),
      ControllerMoveEvent(:final index) => _moveTo(index),
    };
  }

  int _getActualIndex(int itemIndex) {
    if (_cardsCount == 0) return 0;

    return widget.isLoop ? itemIndex % _cardsCount : itemIndex;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_animationController.isAnimating || !_canSwipe) return;

    setState(
      () => _sliderAnimation.updateDrag(
        context: context,
        details: details,
        allowedDirection: widget.allowedSwipeDirection,
      ),
    );
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    if (_animationController.isAnimating || !_canSwipe) return;

    final Size screenSize = MediaQuery.sizeOf(context);
    final double thresholdValue = (screenSize.width * widget.threshold) / 100;

    final bool swipedHorizontally = _sliderAnimation.dragPosition.dx.abs() > thresholdValue;
    final bool swipedVertically =
        _sliderAnimation.dragPosition.dy.abs() > thresholdValue * widget.verticalSwipeThresholdMultiplier;

    if ((swipedHorizontally || swipedVertically) && _canSwipe) {
      final CardStackSwiperDirection direction;

      if (_sliderAnimation.dragPosition.dx.abs() > _sliderAnimation.dragPosition.dy.abs()) {
        direction = _sliderAnimation.dragPosition.dx.isNegative
            ? CardStackSwiperDirection.left
            : CardStackSwiperDirection.right;
      } else {
        direction = _sliderAnimation.dragPosition.dy.isNegative
            ? CardStackSwiperDirection.top
            : CardStackSwiperDirection.bottom;
      }

      _swipe(direction);
    } else {
      await _sliderAnimation.animateBackToCenter(context: context, duration: widget.returnAnimationDuration);
    }
  }

  Future<void> _swipe(CardStackSwiperDirection direction) async {
    if (_animationController.isAnimating || !_canSwipe) return;

    final int oldIndex = _getActualIndex(_currentIndex!);
    final int? nextIndex =
        widget.isLoop || _currentIndex! + 1 < _cardsCount ? _getActualIndex(_currentIndex! + 1) : null;
    final bool isLastCard = !widget.isLoop && nextIndex == null;
    final bool canSwipe = await widget.onSwipe?.call(oldIndex, nextIndex, direction) ?? true;

    if (!canSwipe) {
      if (!mounted) return;

      await _sliderAnimation.animateBackToCenter(context: context, duration: widget.returnAnimationDuration);

      return;
    }

    if (!mounted) return;

    await _sliderAnimation.swipe(context: context, direction: direction, duration: widget.swipeAnimationDuration);

    setState(() {
      _undoableIndex.state = nextIndex;
      _directionHistory.add(direction);
    });

    if (isLastCard) widget.onEnd?.call();
  }

  Future<void> _undo() async {
    if (_directionHistory.isEmpty || _animationController.isAnimating) return;

    final int? newIndex = _undoableIndex.previousState;

    if (newIndex == null) return;

    final CardStackSwiperDirection lastDirection = _directionHistory.last;
    final int? oldIndex = _currentIndex;
    final bool canUndo = widget.onUndo?.call(oldIndex, newIndex, lastDirection) ?? true;

    if (!canUndo) return;

    setState(() {
      _directionHistory.removeLast();
      _undoableIndex.undo();
    });

    await _sliderAnimation.undo(context: context, direction: lastDirection, duration: widget.returnAnimationDuration);
  }

  void _moveTo(int index) {
    if (index < 0 || index >= _cardsCount || index == _currentIndex) return;

    setState(() {
      _undoableIndex.state = index;
      _directionHistory.clear();
    });
  }

  void _onSwipeDirectionChanged(CardStackSwiperDirection direction) {
    switch (direction) {
      case CardStackSwiperDirection.left:
      case CardStackSwiperDirection.right:
        _detectedHorizontalDirection = direction;
      case CardStackSwiperDirection.top:
      case CardStackSwiperDirection.bottom:
        _detectedVerticalDirection = direction;
      case CardStackSwiperDirection.none:
        _detectedHorizontalDirection = CardStackSwiperDirection.none;
        _detectedVerticalDirection = CardStackSwiperDirection.none;
    }

    widget.onSwipeDirectionChange?.call(_detectedHorizontalDirection, _detectedVerticalDirection);
  }

  CardSettings _getSettingsFor(int localIndex) {
    final double t = _sliderAnimation.animationProgress;

    CardSettings getSettings(CardStackSwiperStatus status) => _sliderSettings[status]!;

    return switch (localIndex) {
      0 => getSettings(CardStackSwiperStatus.top),
      1 => CardSettings.lerp(getSettings(CardStackSwiperStatus.end), getSettings(CardStackSwiperStatus.top), t)!,
      2 => CardSettings.lerp(getSettings(CardStackSwiperStatus.start), getSettings(CardStackSwiperStatus.end), t)!,
      3 =>
        CardSettings.lerp(getSettings(CardStackSwiperStatus.invisible), getSettings(CardStackSwiperStatus.start), t)!,
      _ => getSettings(CardStackSwiperStatus.invisible),
    };
  }

  int _getSwipePercentage(double dragPosition) {
    final double thresholdValue = (MediaQuery.sizeOf(context).width * widget.threshold) / 100;

    return thresholdValue == 0 ? 0 : (100 * dragPosition / thresholdValue).ceil();
  }

  Widget _buildFrontCard(BoxConstraints constraints) {
    if (_currentIndex == null) return const SizedBox.shrink();

    final int index = _getActualIndex(_currentIndex!);
    final int horizontalPercentage = _getSwipePercentage(_sliderAnimation.dragPosition.dx);
    final int verticalPercentage = _getSwipePercentage(_sliderAnimation.dragPosition.dy);

    return Transform(
      transform: Matrix4.identity()
        ..translate(_sliderAnimation.dragPosition.dx, _sliderAnimation.dragPosition.dy)
        ..rotateZ(_sliderAnimation.dragAngle),
      alignment: Alignment.center,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onTap: () async => widget.isDisabled ? await widget.onTapDisabled?.call() : widget.onPressed?.call(index),
        child: ConstrainedBox(
          constraints: constraints,
          child: CardStackSwiperItem(
            settings: _getSettingsFor(0),
            child:
                widget.cardBuilder(context, index, horizontalPercentage, verticalPercentage) ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBackCards(BoxConstraints constraints) {
    final List<Widget> cards = [];

    for (int index = 3; index >= 1; index--) {
      if (_currentIndex != null && (_currentIndex! + index < _cardsCount || widget.isLoop)) {
        cards.add(
          ConstrainedBox(
            constraints: constraints,
            child: CardStackSwiperItem(
              settings: _getSettingsFor(index),
              child:
                  widget.cardBuilder(context, _getActualIndex(_currentIndex! + index), 0, 0) ?? const SizedBox.shrink(),
            ),
          ),
        );
      }
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [..._buildBackCards(constraints), _buildFrontCard(constraints)],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controllerSubscription?.cancel();

    super.dispose();
  }
}
