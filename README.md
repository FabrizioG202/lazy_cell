# LazyCell

LazyCell is a lightweight Dart package that provides a simple and efficient way to implement lazy initialization for both synchronous and asynchronous values. ! Currently, the package is not yet published on pub.dev, but it will be soon. For now, include it in your `pubspec.yaml` file as follows:

```yaml
dependencies:
  lazy_cell:
    git:
      url: https://github.com/FabrizioG202/lazy_cell.git
```

## Features

- Supports both synchronous and asynchronous initialization through `FutureOr`
- Caches computed values for improved performance
- Handles errors during initialization
- Allows manual reset of cached values
- Type-safe with generics

## Future Plans
The package is really simple, so there are no particular plans for features. However, if you have a suggestion or a request for a feature that could be useful and fits the package's style and scope, do absolutely feel free to open an issue or a pull request.

One planned feature is to add a `Lazy()` macro, which will allow for a more concise syntax for creating `LazyCell` instances and their related fields. For the time being, I am waiting for the macro feature to be stable in Dart before implementing it.

## Usage

Here's a simple example of how to use LazyCell:

```dart
import 'package:lazy_cell/lazy_cell.dart';

void main() async {
  // Synchronous usage
  final syncCell = LazyCell(() => 42);
  print(syncCell.value);  // Prints: 42

  // Asynchronous usage
  final asyncCell = LazyCell(() async {
    await Future.delayed(Duration(seconds: 1));
    return 'Hello, World!';
  });
  print(await asyncCell.value);  // Prints: Hello, World!

  // Error handling
  final errorCell = LazyCell(() => throw Exception('Failed'));
  try {
    errorCell.value;
  } catch (e) {
    print(e);  // Prints: Exception: Failed
  }

  // Reset cached value
  syncCell.reset();
}
```
## Rationale
This package is meant to be easily integrated into existing codebases that require lazy initialization of values. Similar implementations already exist, such as the very good [rust_core](https://pub.dev/packages/rust_core). However, I found that the API is a bit too complex for my needs, and I wanted to create a simpler and more lightweight alternative. 

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
