// lib/data/resource.dart

// This is a class which gives a result
// <T> means it's a generic type which can be used everywhere
class Resource<T> {
  final Status status;
  final T? data;
  final Exception? error;

  Resource.loading([this.data]) : status = Status.loading, error = null;
  Resource.success(this.data) : status = Status.success, error = null;
  Resource.failure(this.error) : status = Status.failure, data = null;

  bool get isLoading => status == Status.loading;
  bool get isSuccess => status == Status.success;
  bool get isFailure => status == Status.failure;
}

enum Status { loading, success, failure }