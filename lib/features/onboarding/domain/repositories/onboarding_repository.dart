

abstract class OnboardingRepository {
  Future<bool> getSeenOnboarding();
  Future<void> setSeenOnboarding(bool seen);
}