class ApiResult<T> {
  final bool isSuccess;
  final T? data;
  final String? errorMessage;
  final int? statusCode;

  const ApiResult.success(this.data, {this.statusCode})
    : isSuccess = true,
      errorMessage = null;

  const ApiResult.failure(this.errorMessage, {this.statusCode})
    : isSuccess = false,
      data = null;
}
