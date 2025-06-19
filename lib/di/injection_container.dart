import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../core/network/network_info.dart';

// Onboarding imports
import '../features/auth/data/repositories/authrepositoryimpl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../features/onboarding/domain/usecases/get_onboarding_seen.dart';
import '../features/onboarding/domain/usecases/save_onboarding_seen.dart';
import '../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../features/splash/domain/is_user_loged_in.dart';
import '../features/splash/presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => sharedPreferences);

  // Blocs
  sl.registerFactory(() => SplashBloc(
        getOnboardingSeen: sl(),
        isUserLoggedIn: sl(),
      ));
  sl.registerFactory(() => OnboardingBloc(getSeen: sl(), saveSeen: sl()));
  sl.registerLazySingleton(() => GetOnboardingSeen(sl()));
  sl.registerLazySingleton(() => SaveOnboardingSeen(sl()));
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => IsUserLoggedIn(sl()));

  // New: Authentication Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  // Core (NetworkInfo)
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectivity: sl(),
      connectionChecker: sl(),
    ),
  );
}
