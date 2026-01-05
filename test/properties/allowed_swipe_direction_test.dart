import 'package:card_stack_swiper/card_stack_swiper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AllowedSwipeDirection.all() has all directions as true', () {
    const directions = AllowedSwipeDirection.all();
    expect(directions.left, true);
    expect(directions.right, true);
    expect(directions.up, true);
    expect(directions.down, true);
  });

  test('AllowedSwipeDirection.none() has all directions as false', () {
    const directions = AllowedSwipeDirection.none();
    expect(directions.left, false);
    expect(directions.right, false);
    expect(directions.up, false);
    expect(directions.down, false);
  });

  group('AllowedSwipeDirection.only() tests', () {
    test(
        'AllowedSwipeDirection.only(left:true) has only the left direction as true',
        () {
      const directions = AllowedSwipeDirection.only(left: true);
      expect(directions.left, true);
      expect(directions.right, false);
      expect(directions.up, false);
      expect(directions.down, false);
    });

    test(
        'AllowedSwipeDirection.only(right:true) has only the set direction as true',
        () {
      const directions = AllowedSwipeDirection.only(right: true);
      expect(directions.left, false);
      expect(directions.right, true);
      expect(directions.up, false);
      expect(directions.down, false);
    });

    test(
        'AllowedSwipeDirection.only(up:true) has only the set direction as true',
        () {
      const directions = AllowedSwipeDirection.only(up: true);
      expect(directions.left, false);
      expect(directions.right, false);
      expect(directions.up, true);
      expect(directions.down, false);
    });

    test(
        'AllowedSwipeDirection.only(down:true) has only the set direction as true',
        () {
      const directions = AllowedSwipeDirection.only(down: true);
      expect(directions.left, false);
      expect(directions.right, false);
      expect(directions.up, false);
      expect(directions.down, true);
    });
  });

  group('AllowedSwipeDirection.symmetric() tests', () {
    test(
        'AllowedSwipeDirection.symmetric(horizontal:true) has left and right as true',
        () {
      const directions = AllowedSwipeDirection.symmetric(horizontal: true);
      expect(directions.left, true);
      expect(directions.right, true);
      expect(directions.up, false);
      expect(directions.down, false);
    });

    test(
        'AllowedSwipeDirection.symmetric(vertical:true) has up and down as true',
        () {
      const directions = AllowedSwipeDirection.symmetric(vertical: true);
      expect(directions.left, false);
      expect(directions.right, false);
      expect(directions.up, true);
      expect(directions.down, true);
    });
  });
}
