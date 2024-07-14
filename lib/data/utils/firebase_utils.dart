import 'dart:async';


Future<T> convertToFuture<T>(Future<T> firebaseFuture) {
  final completer = Completer<T>();

  firebaseFuture.then((result) {
    completer.complete(result);
  }).catchError((error) {
    completer.completeError(error);
  });

  return completer.future;
}