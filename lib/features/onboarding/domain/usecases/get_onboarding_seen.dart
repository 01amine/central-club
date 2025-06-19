import '../repositories/onboarding_repository.dart';

class GetOnboardingSeen {
  final OnboardingRepository repo;
  GetOnboardingSeen(this.repo);

  Future<bool> call() async {
    return await repo.getSeenOnboarding();
  }
}