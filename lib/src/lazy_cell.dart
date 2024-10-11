import 'dart:async';

/// A class that lazily initializes a value of type [T] using a provided
/// initializer function. The value can be either synchronous or asynchronous.
///
/// The [LazyCell] class provides a way to defer the initialization of a value
/// until it is actually needed. This can be useful for optimizing performance
/// or managing resources more efficiently.
///
/// If the initializer function throws an error, the error will be stored and
/// rethrown when the [value] getter is accessed.
class LazyCell<T> {
  /// Creates a new [LazyCell] with the given initializer function.
  /// The Function will be called only once when the [value] getter is accessed
  LazyCell(this._initializer);

  final FutureOr<T> Function() _initializer;
  T? _value;
  Object? _error;
  bool _initialized = false;
  Future<void>? _initializationFuture;

  /// Accesses the lazily initialized value.
  /// If the value has not been initialized yet, the initializer function will
  /// be called and the result will be stored and returned.
  ///
  /// Throws any error encountered during initialization.
  FutureOr<T> get value {
    if (_initialized) {
      if (_error case final error?) {
        return Future.error(error);
      }
      return _value as T;
    }

    if (_initializationFuture != null) {
      return _initializationFuture!.then((_) => _value as T);
    }

    // This is necessary since the initializer function may be synchronous.
    // or asynchronous and, in case of the latter, we want to keep
    // this function synchronous.
    final result = _initializer();
    if (result is Future<T>) {
      _initializationFuture = result.then(_setValue, onError: _setError);
      return result;
    } else {
      _setValue(result);
      return result;
    }
  }

  void _setValue(T value) {
    _value = value;
    _initialized = true;
    _initializationFuture = null;
  }

  void _setError(Object error) {
    _error = error;
    _initialized = true;
    _initializationFuture = null;
  }

  /// Resets the cell to its initial state.
  void reset() {
    _value = null;
    _error = null;
    _initialized = false;
    _initializationFuture = null;
  }
}
