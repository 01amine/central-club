import 'package:flutter/material.dart';
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';
import '../../../../core/theme/theme.dart';

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

        // Profile avatar
        Container(
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
              // Handle logout
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
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
