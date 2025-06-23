import 'package:flutter/material.dart';
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/user.dart';
import '../../../reserve_field/domain/entities/reservation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final User mockUser = User(
    id: '1',
    fullName: 'Amine Heddouche',
    email: 'amine@example.com',
    phoneNumber: '+213 552236372',
    birthday: DateTime(2005, 02, 18),
  );

  final double userBalance = 1500.50;
  final double userRating = 4.5;
  final List<Reservation> recentReservations = [
    Reservation(
      reservationId: '1',
      fieldName: 'Terrain Central',
      fieldType: 'Soccer',
      date: '05/06/2025',
      startTime: '9:30',
      status: 'confirmed',
      fieldId: '1',
      timeSlotId: '2',
      endTime: '10:00',
      price: 500.0,
      createdAt: DateTime(2025),
    ),
    Reservation(
      reservationId: '2',
      fieldName: 'Terrain Central',
      fieldType: 'Soccer',
      date: '05/06/2025',
      startTime: '9:30',
      status: 'confirmed',
      fieldId: '1',
      timeSlotId: '2',
      endTime: '10:00',
      price: 500.0,
      createdAt: DateTime(2025),
    ),
    Reservation(
      reservationId: '3',
      fieldName: 'Terrain Central',
      fieldType: 'Soccer',
      date: '05/06/2025',
      startTime: '9:30',
      status: 'confirmed',
      fieldId: '1',
      timeSlotId: '2',
      endTime: '10:00',
      price: 500.0,
      createdAt: DateTime(2025),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
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
          _buildBackground(),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: _buildProfileContent(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
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
                  AppTheme.primaryColor.withOpacity(0.8),
                  AppTheme.primaryColor,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.05,
        vertical: 20,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.cardColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.borderColor.withOpacity(0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.primaryTextColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Retourner',
                    style: TextStyle(
                      color: AppTheme.primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // User balance display
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
                Image.asset(
                  AppImages.coin_icon,
                  height: context.height * 0.06,
                  width: context.width * 0.06,
                ),
                SizedBox(width: context.width * 0.02),
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
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      child: Column(
        children: [
          SizedBox(height: context.height * 0.02),
          _buildProfileSection(context),
          SizedBox(height: context.height * 0.04),
          _buildRecentReservationsSection(context),
          SizedBox(height: context.height * 0.04),
          _buildLogoutButton(context),
          SizedBox(height: context.height * 0.03),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.06),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.cardColor.withOpacity(0.4),
            AppTheme.secondaryColor.withOpacity(0.3),
          ],
        ),
        border: Border.all(
          color: AppTheme.borderColor.withOpacity(0.3),
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
      child: Column(
        children: [
          // Profile Avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.borderColor.withOpacity(0.5),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.overlayColor.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Container(
                color: AppTheme.accentColor.withOpacity(0.3),
                child: Icon(
                  Icons.person,
                  color: AppTheme.primaryTextColor,
                  size: 60,
                ),
              ),
            ),
          ),
          SizedBox(height: context.height * 0.03),

          // User Name
          Text(
            mockUser.fullName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.height * 0.02),

          // Rating Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                  4,
                  (index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 24,
                      )),
              Icon(
                Icons.star_half,
                color: Colors.amber,
                size: 24,
              ),
              SizedBox(width: context.width * 0.02),
              Text(
                userRating.toString(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReservationsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.cardColor.withOpacity(0.3),
        border: Border.all(
          color: AppTheme.borderColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.overlayColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DERNIERES RESERVATIONS',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
          SizedBox(height: context.height * 0.025),

          // Recent Reservations List
          ...recentReservations
              .take(3)
              .map((reservation) => _buildReservationItem(context, reservation))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildReservationItem(BuildContext context, Reservation reservation) {
    return Container(
      margin: EdgeInsets.only(bottom: context.height * 0.015),
      padding: EdgeInsets.all(context.width * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppTheme.secondaryColor.withOpacity(0.2),
        border: Border.all(
          color: AppTheme.borderColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Réservation',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryTextColor,
                        fontSize: 12,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  reservation.fieldName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.primaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppTheme.secondaryTextColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    reservation.date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryTextColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppTheme.secondaryTextColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    reservation.startTime,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryTextColor,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showLogoutDialog(context);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.red.withOpacity(0.5),
            width: 2,
          ),
          color: Colors.red.withOpacity(0.1),
        ),
        child: Text(
          'DECONNEXION',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Déconnexion',
            style: TextStyle(
              color: AppTheme.primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Êtes-vous sûr de vouloir vous déconnecter?',
            style: TextStyle(
              color: AppTheme.secondaryTextColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                _performLogout(context);
              },
              child: Text(
                'Déconnexion',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }
}
