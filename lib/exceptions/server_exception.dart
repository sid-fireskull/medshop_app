class ServerException implements Exception
{
  String message;
  ServerException(String message)
  {
    this.message = message;
  }

  String toString()
  {
    return this.message;
  }
}