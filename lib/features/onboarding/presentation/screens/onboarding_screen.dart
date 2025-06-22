import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/images.dart';
import '../../domain/entities/onboarding_page.dart';
import '../bloc/onboarding_bloc.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late final List<OnboardingPage> _pages;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pages = [
      OnboardingPage(
        title: "Central Club Sportif",
        description:
            "Découvrez nos terrains de football aux normes internationales avec éclairage LED et pelouse synthétique de dernière génération.",
        assetPath: AppImages.onboarding1,
      ),
      OnboardingPage(
        title: "Courts de Padel Modernes",
        description:
            "Profitez de nos courts de padel climatisés avec surface professionnelle et équipements haut de gamme pour une expérience unique.",
        assetPath: AppImages.onboarding2,
      ),
      OnboardingPage(
        title: "Réservation Simplifiée",
        description:
            "Réservez vos créneaux en quelques clics, gérez vos réservations et profitez d'une expérience utilisateur fluide et intuitive.",
        assetPath: AppImages.onboarding3,
      ),
    ];

    // Start initial animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.read<OnboardingBloc>().add(CompleteOnboarding());
    }
  }

  void _onSkip() {
    context.read<OnboardingBloc>().add(CompleteOnboarding());
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _slideController.reset();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double containerHeight = size.height * 0.45;

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingComplete) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background Images with Overlay
            Positioned.fill(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            page.assetPath,
                            fit: BoxFit.cover,
                          ),
                          // Dark overlay for better text contrast
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Content Container
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: containerHeight,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF1A1A1A).withOpacity(0.95),
                            const Color(0xFF1A1A1A),
                            const Color(0xFF000000),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        border: Border.all(
                          color: const Color(0xFF333333),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Progress indicator at top
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            width: 60,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF333333),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          // Content Area
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(32, 24, 32, 16),
                              child: AnimatedBuilder(
                                animation: _slideAnimation,
                                builder: (context, child) {
                                  return SlideTransition(
                                    position: _slideAnimation,
                                    child: FadeTransition(
                                      opacity: _slideController,
                                      child: SingleChildScrollView(
                                        // Added SingleChildScrollView here
                                        child: _buildPageContent(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Navigation Area
                          Container(
                            padding: const EdgeInsets.fromLTRB(32, 16, 32, 40),
                            child: Column(
                              children: [
                                // Page Indicators
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _pages.length,
                                    (index) => AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      width: _currentIndex == index ? 24 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: _currentIndex == index
                                            ? Colors.white
                                            : const Color(0xFF666666),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // Navigation Buttons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildSkipButton(),
                                    _buildNextButton(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent() {
    final page = _pages[_currentIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          page.title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
        ),

        const SizedBox(height: 20),

        // Description
        Text(
          page.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFFB0B0B0),
                height: 1.6,
                fontSize: 16,
              ),
        ),

        const SizedBox(height: 24),

        // Feature highlight
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF333333),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Central Club Premium',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: _onSkip,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: Colors.transparent,
      ),
      child: Text(
        'Passer',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF666666),
            ),
      ),
    );
  }

  Widget _buildNextButton() {
    final isLastPage = _currentIndex == _pages.length - 1;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF333333), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF444444),
          width: 1,
        ),
      ),
      child: TextButton(
        onPressed: _onNext,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLastPage ? 'Commencer' : 'Suivant',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(width: 8),
            Icon(
              isLastPage ? Icons.check : Icons.arrow_forward,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
