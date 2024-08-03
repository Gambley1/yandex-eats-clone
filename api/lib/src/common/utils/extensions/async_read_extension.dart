import 'package:dart_frog/dart_frog.dart';

extension AsyncContextReadExtension on RequestContext {
  Future<T> futureRead<T>() => read<Future<T>>();
}
