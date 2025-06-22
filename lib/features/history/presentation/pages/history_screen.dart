import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';
import '../../../../core/theme/theme.dart';
import '../../../home/presentation/cubit/bottom_navigation_cubit.dart';
import '../../../reserve_field/domain/entities/reservation.dart';
import '../bloc/history_bloc.dart';
import '../../../../di/injection_container.dart';

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

    // Dispatch event to load reservations
    sl<HistoryBloc>().add(GetUserReservationsEvent());
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
                        child: BlocBuilder<HistoryBloc, HistoryState>(
                          bloc: sl<HistoryBloc>(),
                          builder: (context, state) {
                            if (state is HistoryLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is HistoryLoaded) {
                              if (state.reservations.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No reservations found.",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppTheme.secondaryTextColor,
                                        ),
                                  ),
                                );
                              }
                              return _buildHistoryList(
                                  context, state.reservations);
                            } else if (state is HistoryError) {
                              return Center(
                                child: Text(
                                  "Error: ${state.message}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.red,
                                      ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
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
            context.read<BottomNavigationCubit>().changeTab(2);
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

  Widget _buildHistoryList(
      BuildContext context, List<Reservation> reservations) {
    return ListView.separated(
      itemCount: reservations.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: context.height * 0.02),
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return _buildHistoryCard(
          context,
          reservation.fieldName,
          reservation.date,
          "${reservation.startTime} - ${reservation.endTime}",
          reservation.reservationId,
        );
      },
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    String title,
    String date,
    String time,
    String reservationId,
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
                      Navigator.pushNamed(context, '/history_details',
                          arguments: reservationId);
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
