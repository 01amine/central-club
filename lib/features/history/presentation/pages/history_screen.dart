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
  late HistoryBloc _historyBloc;

  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;
  ReservationFilter _currentFilter = ReservationFilter.all;

  @override
  void initState() {
    super.initState();
    _historyBloc = sl<HistoryBloc>();
    _initializeAnimations();
    _loadReservations();
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

  void _loadReservations() {
    _historyBloc.add(GetUserReservationsEvent());
  }

  void _refreshReservations() {
    _historyBloc.add(RefreshReservationsEvent());
  }

  void _filterReservations(ReservationFilter filter) {
    setState(() {
      _currentFilter = filter;
    });
    _historyBloc.add(FilterReservationsEvent(filter: filter));
  }

  void _searchReservations(String query) {
    _historyBloc.add(SearchReservationsEvent(query: query));
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        _loadReservations();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    _historyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _historyBloc,
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: Stack(
          children: [
            _buildBackground(),
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
                        _buildHeader(context),
                        SizedBox(height: context.height * 0.03),
                        _buildTitle(context),
                        SizedBox(height: context.height * 0.02),
                        _buildSearchAndFilters(context),
                        SizedBox(height: context.height * 0.02),
                        Expanded(
                          child: BlocBuilder<HistoryBloc, HistoryState>(
                            builder: (context, state) {
                              return _buildContent(context, state);
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
                  AppTheme.primaryColor.withOpacity(0.7),
                  AppTheme.primaryColor.withOpacity(0.9),
                ],
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
            // Search toggle button
            GestureDetector(
              onTap: _toggleSearch,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.borderColor.withOpacity(0.5),
                  ),
                ),
                child: Icon(
                  _isSearchVisible ? Icons.close : Icons.search,
                  color: AppTheme.primaryTextColor,
                  size: 20,
                ),
              ),
            ),

            SizedBox(width: context.width * 0.03),

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

  Widget _buildSearchAndFilters(BuildContext context) {
    return Column(
      children: [
        // Search bar
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isSearchVisible ? 50 : 0,
          child: _isSearchVisible
              ? Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.borderColor.withOpacity(0.5),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchReservations,
                    style: TextStyle(color: AppTheme.primaryTextColor),
                    decoration: InputDecoration(
                      hintText: 'Rechercher des réservations...',
                      hintStyle: TextStyle(color: AppTheme.secondaryTextColor),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppTheme.secondaryTextColor,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),

        if (_isSearchVisible) SizedBox(height: context.height * 0.02),

        // Filter chips - Only 3 filters now
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip('Tous', ReservationFilter.all),
              _buildFilterChip('À venir', ReservationFilter.upcoming),
              _buildFilterChip('Passées', ReservationFilter.past),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, ReservationFilter filter) {
    final isSelected = _currentFilter == filter;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => _filterReservations(filter),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.accentColor.withOpacity(0.3)
                : AppTheme.cardColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppTheme.accentColor
                  : AppTheme.borderColor.withOpacity(0.5),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppTheme.primaryTextColor
                  : AppTheme.secondaryTextColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HistoryState state) {
    print('Current state: ${state.runtimeType}');

    if (state is HistoryLoading) {
      return _buildLoadingState();
    } else if (state is HistoryRefreshing) {
      return _buildRefreshingState(context, state.reservations);
    } else if (state is HistoryLoaded ||
        state is HistoryFiltered ||
        state is HistorySearched) {
      final reservations = _getReservationsFromState(state);
      print('Reservations count: ${reservations.length}');

      if (reservations.isEmpty) {
        return _buildEmptyState(context, state);
      }

      return _buildHistoryList(context, reservations, state);
    } else if (state is HistoryError) {
      return _buildErrorState(context, state.message);
    }

    return const SizedBox.shrink();
  }

  List<Reservation> _getReservationsFromState(HistoryState state) {
    if (state is HistoryLoaded) return state.reservations;
    if (state is HistoryFiltered) return state.reservations;
    if (state is HistorySearched) return state.reservations;
    return [];
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Chargement des réservations...',
            style: TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshingState(
      BuildContext context, List<Reservation> reservations) {
    return Stack(
      children: [
        _buildHistoryList(context, reservations, null),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Actualisation...',
                  style: TextStyle(
                    color: AppTheme.primaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, HistoryState state) {
    String message;
    String subtitle;

    if (state is HistorySearched) {
      message = 'Aucun résultat trouvé';
      subtitle = 'Essayez avec d\'autres mots-clés';
    } else if (state is HistoryFiltered) {
      message = 'Aucune réservation trouvée';
      subtitle = _getFilterEmptyMessage(state.currentFilter);
    } else {
      message = 'Aucune réservation';
      subtitle = 'Vos réservations apparaîtront ici';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppTheme.secondaryTextColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.secondaryTextColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryTextColor.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (state is HistorySearched || state is HistoryFiltered)
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _currentFilter = ReservationFilter.all;
                  _isSearchVisible = false;
                });
                _loadReservations();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                foregroundColor: AppTheme.primaryTextColor,
              ),
              child: const Text('Réinitialiser'),
            ),
        ],
      ),
    );
  }

  String _getFilterEmptyMessage(ReservationFilter filter) {
    switch (filter) {
      case ReservationFilter.upcoming:
        return 'Aucune réservation à venir';
      case ReservationFilter.past:
        return 'Aucune réservation passée';
      default:
        return 'Aucune réservation trouvée';
    }
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.red,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryTextColor,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadReservations,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor.withOpacity(0.2),
              foregroundColor: AppTheme.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, List<Reservation> reservations,
      HistoryState? state) {
    return RefreshIndicator(
      onRefresh: () async => _refreshReservations(),
      color: AppTheme.accentColor,
      backgroundColor: AppTheme.cardColor,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: reservations.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: context.height * 0.02),
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return _buildHistoryCard(
            context,
            reservation,
            index,
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    Reservation reservation,
    int index,
  ) {
    final isUpcoming = _isUpcomingReservation(reservation);
    final statusColor = _getStatusColor(reservation.fieldType);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
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
            _buildCardBackground(),
            _buildCardOverlay(),
            _buildCardContent(context, reservation, isUpcoming, statusColor),
            _buildStatusBadge(reservation.status, statusColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBackground() {
    return Positioned.fill(
      child: Image.asset(
        AppImages.backgroundimage,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCardOverlay() {
    return Positioned.fill(
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
    );
  }

  Widget _buildCardContent(
    BuildContext context,
    Reservation reservation,
    bool isUpcoming,
    Color statusColor,
  ) {
    return Padding(
      padding: EdgeInsets.all(context.width * 0.05),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reservation.fieldName,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppTheme.primaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.height * 0.005),
                Text(
                  reservation.fieldType,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryTextColor,
                        fontStyle: FontStyle.italic,
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
                      reservation.date,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryTextColor,
                          ),
                    ),
                    SizedBox(width: context.width * 0.03),
                    Icon(
                      Icons.access_time,
                      color: AppTheme.secondaryTextColor,
                      size: 16,
                    ),
                    SizedBox(width: context.width * 0.01),
                    Text(
                      reservation.startTime,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  arguments: reservation.reservationId);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    );
  }

  Widget _buildStatusBadge(String status, Color statusColor) {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: statusColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }

  bool _isUpcomingReservation(Reservation reservation) {
    try {
      final reservationDate =
          DateTime.tryParse(reservation.date.split('/').reversed.join('-'));
      return reservationDate != null && reservationDate.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'soccer':
        return Colors.green;
      case 'padel':
        return Colors.orange;
      default:
        return AppTheme.secondaryTextColor;
    }
  }
}
