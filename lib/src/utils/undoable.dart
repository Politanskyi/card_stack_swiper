/// A generic wrapper for a value that keeps a history of its previous states.
/// Enables undo functionality.
class Undoable<T> {
  Undoable(
    this._value, {
    Undoable<T>? previousValue,
  }) : _previous = previousValue;

  T _value;
  Undoable<T>? _previous;

  /// The current state of the value.
  T get state => _value;

  /// The state of the value before the last change. Returns null if there is no previous state.
  T? get previousState => _previous?.state;

  /// Sets a new value, saving the old value in the history.
  set state(T newValue) {
    _previous = Undoable(_value, previousValue: _previous);
    _value = newValue;
  }

  /// Reverts the value to its previous state. Does nothing if there is no history.
  void undo() {
    if (_previous != null) {
      _value = _previous!._value;
      _previous = _previous?._previous;
    }
  }
}
