import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Concrete implementation of [NetworkInfo] using [Connectivity] and [InternetConnectionCheckerPlus].
/// This class belongs to the Core layer in Data, as it deals with external infrastructure.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final InternetConnection  connectionChecker;

  NetworkInfoImpl(Object object, {
    required this.connectivity,
    required this.connectionChecker,
  });

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return await connectionChecker.hasInternetAccess;
  }
}