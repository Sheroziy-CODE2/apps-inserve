class HttpException implements Exception {
  final String message;

  //we need to clear what is this class

  HttpException(this.message);

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}
