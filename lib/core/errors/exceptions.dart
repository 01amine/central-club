class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Server Error'});
}

class CacheException implements Exception {}