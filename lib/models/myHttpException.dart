class MyHttpException implements Exception {
  final String message;
  MyHttpException(this.message);

  @override
  String toString() {
    return message;
    // return super.toString();  ->  Instance of MyHttpException
  }
}
