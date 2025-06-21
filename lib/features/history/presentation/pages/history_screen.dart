import 'package:flutter/material.dart';
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';
import '../../../../core/theme/theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
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

                      SizedBox(height: context.height * 0.06),

                      // Title
                      _buildTitle(context),

                      SizedBox(height: context.height * 0.04),

                      // History List
                      Expanded(
                        child: _buildHistoryList(context),
                      ),
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
        GestureDetector(
          onTap: () {
            // Handle profile tap
          },
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
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "HISTORIQUE",
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: AppTheme.primaryTextColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    final historyItems = [
      {
        'title': 'Réservation Terrain Central',
        'date': '05/06/2025',
        'time': '9:30',
      },
      {
        'title': 'Réservation Terrain Central',
        'date': '05/06/2025',
        'time': '9:30',
      },
      {
        'title': 'Réservation Terrain Central',
        'date': '05/06/2025',
        'time': '9:30',
      },
      {
        'title': 'Réservation Terrain Central',
        'date': '05/06/2025',
        'time': '9:30',
      },
    ];

    return ListView.separated(
      itemCount: historyItems.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: context.height * 0.02),
      itemBuilder: (context, index) {
        return _buildHistoryCard(
          context,
          historyItems[index]['title']!,
          historyItems[index]['date']!,
          historyItems[index]['time']!,
        );
      },
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    String title,
    String date,
    String time,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.overlayColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                AppImages.backgroundimage,
                fit: BoxFit.cover,
              ),
            ),
            // Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.cardColor.withOpacity(0.8),
                      AppTheme.secondaryColor.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(context.width * 0.05),
              child: Row(
                children: [
                  // Left content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.primaryTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(height: context.height * 0.015),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: AppTheme.secondaryTextColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              date,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppTheme.secondaryTextColor,
                                  ),
                            ),
                            const SizedBox(width: 20),
                            Icon(
                              Icons.access_time,
                              color: AppTheme.secondaryTextColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              time,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppTheme.secondaryTextColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // "Voir Plus" button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/history_details');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.borderColor.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Voir Plus",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.primaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.primaryTextColor,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
