
## [1.0.0+2]

### Fixed
- Update version to 1.0.0+2 and improve code formatting for constructors

---

## [1.0.0+1]

### Changed
- Refactored internal code for improved readability and consistency.
- Optimized gesture handling logic in `_onPanEnd` and `_onPanUpdate`.

---

## [1.0.0]

### Added
- Initial release of the `card_stack_swiper` package.
- Swiping in all four directions (left, right, top, bottom) with `AllowedSwipeDirection`.
- Programmatic control via `CardStackSwiperController` (`swipe`, `undo`, `moveTo`).
- A comprehensive suite of callbacks: `onSwipe`, `onUndo`, `onEnd`, `onPressed`.
- Real-time swipe direction tracking with `onSwipeDirectionChange`.
- `isDisabled` and `onTapDisabled` properties to control user interaction.
- `initialIndex` property to start the stack at a specific card.
- `isLoop` property for infinite scrolling.
- `cardBuilder` now provides `horizontalOffsetPercentage` and `verticalOffsetPercentage` for creating interactive cards.
- Performance optimization using `AnimatedBuilder` to prevent unnecessary widget rebuilds.
- Full Dartdoc documentation for the public API.
