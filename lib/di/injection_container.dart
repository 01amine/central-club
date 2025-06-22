import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:soccer_complex/core/constants/end_points.dart';
import '../core/network/network_info.dart';
import '../features/auth/data/datasource/local_data.dart';
import '../features/auth/data/datasource/local_data_impl.dart';
import '../features/auth/data/datasource/remote_data.dart';
import '../features/auth/data/datasource/remote_data_impl.dart';
import '../features/auth/data/repositories/authrepositoryimpl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/clear_token.dart';
import '../features/auth/domain/usecases/get_token.dart';
import '../features/auth/domain/usecases/login_user.dart';
import '../features/auth/domain/usecases/save_token.dart';
import '../features/auth/domain/usecases/signup_user.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/history/presentation/bloc/history_bloc.dart';
import '../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../features/onboarding/domain/usecases/get_onboarding_seen.dart';
import '../features/onboarding/domain/usecases/save_onboarding_seen.dart';
import '../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../features/reserve_field/data/datasource/field_local_datasource.dart';
import '../features/reserve_field/data/datasource/field_remote_datasource.dart';
import '../features/reserve_field/data/repository/field_repository_impl.dart';
import '../features/reserve_field/domain/repositories/field_repository.dart';
import '../features/reserve_field/domain/usecase/cancel_reservation.dart';
import '../features/reserve_field/domain/usecase/get_field_schedule.dart';
import '../features/reserve_field/domain/usecase/get_user_reservations.dart';
import '../features/reserve_field/domain/usecase/make_reservation.dart';
import '../features/reserve_field/presentation/bloc/field_reservation_bloc.dart';
import '../features/splash/domain/is_user_loged_in.dart';
import '../features/splash/presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await sl.reset();

  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      sl<InternetConnection>(),
      connectivity: sl<Connectivity>(),
      connectionChecker: sl<InternetConnection>(),
    ),
  );

  // Auth Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
        client: sl<http.Client>(), baseUrl: EndPoints.baseUrl),
  );

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Auth Use Cases
  sl.registerLazySingleton<LoginUser>(() => LoginUser(sl<AuthRepository>()));
  sl.registerLazySingleton<SignupUser>(() => SignupUser(sl<AuthRepository>()));
  sl.registerLazySingleton<SaveToken>(() => SaveToken(sl<AuthRepository>()));
  sl.registerLazySingleton<GetToken>(() => GetToken(sl<AuthRepository>()));
  sl.registerLazySingleton<ClearToken>(() => ClearToken(sl<AuthRepository>()));

  // Onboarding Repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl<SharedPreferences>()),
  );

  // Onboarding Use Cases
  sl.registerLazySingleton<GetOnboardingSeen>(
      () => GetOnboardingSeen(sl<OnboardingRepository>()));
  sl.registerLazySingleton<SaveOnboardingSeen>(
      () => SaveOnboardingSeen(sl<OnboardingRepository>()));

  // Splash Use Cases
  sl.registerLazySingleton<IsUserLoggedIn>(
    () => IsUserLoggedIn(sl<AuthRepository>()),
  );

  // Field Reservation Data Sources
  sl.registerLazySingleton<FieldRemoteDataSource>(
    () => FieldRemoteDataSourceImpl(
        client: sl<http.Client>(), baseUrl: EndPoints.baseUrl),
  );
  sl.registerLazySingleton<FieldLocalDataSource>(
    () => FieldLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Field Reservation Repository
  sl.registerLazySingleton<FieldRepository>(
    () => FieldRepositoryImpl(
      remoteDataSource: sl<FieldRemoteDataSource>(),
      localDataSource: sl<FieldLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Field Reservation Use Cases
  sl.registerLazySingleton<GetFieldSchedules>(
      () => GetFieldSchedules(sl<FieldRepository>()));
  sl.registerLazySingleton<MakeReservation>(
      () => MakeReservation(sl<FieldRepository>()));
  sl.registerLazySingleton<GetUserReservations>(
      () => GetUserReservations(sl<FieldRepository>()));
  sl.registerLazySingleton<CancelReservation>(
      () => CancelReservation(sl<FieldRepository>()));

  // BLoCs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUser: sl<LoginUser>(),
      signupUser: sl<SignupUser>(),
      saveToken: sl<SaveToken>(),
      clearToken: sl(),
    ),
  );

  sl.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(
      getSeen: sl<GetOnboardingSeen>(),
      saveSeen: sl<SaveOnboardingSeen>(),
    ),
  );

  sl.registerFactory<SplashBloc>(
    () => SplashBloc(
      getOnboardingSeen: sl<GetOnboardingSeen>(),
      isUserLoggedIn: sl<IsUserLoggedIn>(),
    ),
  );

  sl.registerFactory<FieldReservationBloc>(
    () => FieldReservationBloc(
      getFieldSchedules: sl<GetFieldSchedules>(),
      makeReservation: sl<MakeReservation>(),
      getUserReservations: sl<GetUserReservations>(),
      cancelReservation: sl<CancelReservation>(),
    ),
  );
  sl.registerFactory(() => HistoryBloc(getUserReservations: sl()));
}
