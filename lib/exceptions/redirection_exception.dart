class RedirectionException implements Exception {
  String error;
  RedirectionException(String error) {
    this.error = error;
  }

  String toString()
  {
    return this.error;
  }
}
