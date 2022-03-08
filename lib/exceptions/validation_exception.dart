class ValidationException implements Exception {
  dynamic errors;

  ValidationException(dynamic errors) {
    this.errors = errors;
  }

  String toString() {
    int count = 1;
    List<String> messages = new List();
    if (errors != null) {
      errors.forEach((k, v) {
        messages.add("$count.${v.join('\n')}");
        count++;
      });
    }
    return messages.join("\n");
  }
}
