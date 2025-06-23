import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart'; // Import your AuthBloc

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
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

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Stack(
              children: [
                Image.asset(
                  AppImages.home_background,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.overlayColor,
                        AppTheme.primaryColor.withOpacity(0.7),
                        AppTheme.primaryColor.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.05,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(context),

                      SizedBox(height: context.height * 0.08),

                      // Title and subtitle
                      _buildTitleSection(context),

                      SizedBox(height: context.height * 0.05),

                      // Settings options
                      Expanded(
                        child: _buildSettingsOptions(context),
                      ),

                      SizedBox(height: context.height * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    double userBalance = 1500.50;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        Image.asset(
          AppImages.logo_png,
          width: context.width * 0.2,
          height: context.width * 0.2,
          fit: BoxFit.contain,
        ),

        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: context.width * 0.02),
              decoration: BoxDecoration(
                color: AppTheme.cardColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppTheme.borderColor,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.overlayColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Coin icon
                  Image.asset(
                    AppImages.coin_icon,
                    height: context.height * 0.06,
                    width: context.width * 0.06,
                  ),
                  SizedBox(width: context.width * 0.02),
                  // Balance text
                  Text(
                    '${userBalance.toStringAsFixed(2)} DA',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),

            SizedBox(width: context.width * 0.03),

            // Profile avatar
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.borderColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.overlayColor,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: AppTheme.accentColor,
                    child: Icon(
                      Icons.person,
                      color: AppTheme.secondaryTextColor,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Column(
      children: [
        Text(
          "PARAMÈTRES",
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.primaryTextColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.height * 0.03),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.cardColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.borderColor.withOpacity(0.3),
            ),
          ),
          child: Text(
            "Configurer ici vos paramètres, préférences, ou vous pouvez vous déconnecter.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.secondaryTextColor,
                  height: 1.4,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsOptions(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSettingsOption(
            context: context,
            icon: Icons.visibility,
            title: "Choisir Thème",
            hasDropdown: true,
            onTap: () {
              // Handle theme selection
            },
          ),
          SizedBox(height: context.height * 0.02),
          _buildSettingsOption(
            context: context,
            icon: Icons.lock,
            title: "Confidentialité et sécurité",
            hasDropdown: true,
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          SizedBox(height: context.height * 0.02),
          _buildSettingsOption(
            context: context,
            icon: Icons.info,
            title: "À propos",
            hasDropdown: true,
            onTap: () {
              // Navigate to about screen
            },
          ),
          SizedBox(height: context.height * 0.02),
          _buildSettingsOption(
            context: context,
            icon: Icons.logout,
            title: "Déconnexion",
            hasDropdown: true,
            onTap: () {
              // Dispatch LogoutRequested event
              BlocProvider.of<AuthBloc>(context).add(const LogoutRequested());
            },
          ),
          // Listen for AuthState changes to navigate after logout
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthInitial) {
                // Navigate to login screen after successful logout
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              } else if (state is AuthError) {
                // Optionally show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: Container(), // Empty container as listener child
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool hasDropdown,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.cardColor.withOpacity(0.3),
              AppTheme.secondaryColor.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.borderColor.withOpacity(0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.overlayColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Icon(
              icon,
              color: AppTheme.primaryTextColor,
              size: 24,
            ),

            SizedBox(width: context.width * 0.05),

            // Title
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.primaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),

            // Dropdown arrow
            if (hasDropdown)
              Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.primaryTextColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
