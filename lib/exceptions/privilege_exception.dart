class PrivilegeException implements Exception
{
  String message;
  PrivilegeException(String message)
  {
    this.message = message;
  }

  String toString()
  {
    return this.message;
  }
}