import '../repositories/onboarding_repository.dart';

class SaveOnboardingSeen {
  final OnboardingRepository repo;
  SaveOnboardingSeen(this.repo);

  Future<void> call() async {
    await repo.setSeenOnboarding(true);
  }
}