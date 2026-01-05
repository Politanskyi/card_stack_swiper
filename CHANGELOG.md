## [1.1.1]

### Added
- `emptyCardBuilder` parameter to display custom widget when all cards are swiped and `isLoop` is false
- `CardStackSwiperEmptyCardBuilder` typedef for building empty state widget
- Smooth animated transition between card stack and empty state using `AnimatedSwitcher`
- Comprehensive test suite with 45 tests covering all plugin functionality
- Unit tests for `Undoable` utility class
- Unit tests for `AllowedSwipeDirection` configuration class
- Unit and widget tests for `CardStackSwiperController`
- Widget tests for main `CardStackSwiper` functionality
- Test helpers for card building, finders, gestures, and app pumping
- Tests for new `emptyCardBuilder` functionality

### Changed
- Updated `_allCardsSwiped` logic to properly handle `null` index state
- Modified `didUpdateWidget` logic to preserve index state when `emptyCardBuilder` is used
- Improved state management for end-of-stack scenarios
- Refactored `CardStackSwiperContent` widget to encapsulate `AnimatedSwitcher` logic
- Enhanced test coverage from basic functionality to comprehensive API testing
- Optimized test structure to work with CardStackSwiper's multi-card display architecture

### Fixed
- Fixed empty state not displaying when all cards are swiped with `isLoop` disabled
- Resolved index reset issue that prevented empty card builder from showing
- Fixed controller widget tests to use `pumpAndSettle()` for proper animation handling
- Corrected test assertions to handle CardStackSwiper's multiple card display structure
- Resolved lint warnings including unused variables and print statements
- Fixed test helper imports and gesture implementations

## [1.0.3]

### Changed
- Updated version to 1.0.3 in `pubspec.yaml`.
- Improved slider settings update logic in `card_stack_swiper_slider_state.dart` to properly handle widget property changes.

## [1.0.2]

### Changed
- Increased MinimumOSVersion from 12.0 to 13.0 in `AppFrameworkInfo.plist`.
- Updated `IPHONEOS_DEPLOYMENT_TARGET` from 12.0 to 13.0 in `project.pbxproj`.
- Bumped version to 1.0.2 in `pubspec.yaml`.

## [1.0.1]

### Changed
- Refactored code for improved readability and maintainability
- Update version to 1.0.1

## [1.0.0+4]

### Changed
- Refactor drag update logic in card_animation.dart for improved readability and maintainability
- Update version to 1.0.0+4 and document changes in CHANGELOG.md

## [1.0.0+3]

### Fixed
- Update version to 1.0.0+3 and document changes in CHANGELOG.md

## [1.0.0+2]

### Fixed
- Update version to 1.0.0+2 and improve code formatting for constructors

## [1.0.0+1]

### Changed
- Refactored internal code for improved readability and consistency.
- Optimized gesture handling logic in `_onPanEnd` and `_onPanUpdate`

## [1.0.0]

### Added
- Initial release of the `card_stack_swiper` package
- Swiping in all four directions (left, right, top, bottom) with `AllowedSwipeDirection`
- Programmatic control via `CardStackSwiperController` (`swipe`, `undo`, `moveTo`)
- A comprehensive suite of callbacks: `onSwipe`, `onUndo`, `onEnd`, `onPressed`
- Real-time swipe direction tracking with `onSwipeDirectionChange`
- `isDisabled` and `onTapDisabled` properties to control user interaction
- `initialIndex` property to start the stack at a specific card
- `isLoop` property for infinite scrolling
- `cardBuilder` now provides `horizontalOffsetPercentage` and `verticalOffsetPercentage` for creating interactive cards
- Performance optimization using `AnimatedBuilder` to prevent unnecessary widget rebuilds
- Full Dartdoc documentation for the public API
