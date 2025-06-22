import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/available_date.dart'; 
import '../../domain/entities/available_time_slot.dart'; 
import '../../domain/entities/field_schedule.dart'; 
import '../../domain/entities/reservation_request.dart'; 
import '../bloc/field_reservation_bloc.dart'; 
import '../bloc/field_reservation_event.dart'; 
import '../bloc/field_reservation_state.dart'; 

class ReserveFieldScreen extends StatefulWidget {
  final Field fieldType;

  const ReserveFieldScreen({
    super.key,
    required this.fieldType,
  });

  @override
  State<ReserveFieldScreen> createState() => _ReserveFieldScreenState();
}

class _ReserveFieldScreenState extends State<ReserveFieldScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<FieldSchedule> fieldSchedules = []; 
  int selectedFieldIndex = 0;
  String? selectedTimeSlotId;
  String? selectedDate;
  AvailableTimeSlot? selectedTimeSlot;
  FieldSchedule? selectedField;

  final PageController _fieldPageController = PageController(
    viewportFraction: 0.7,
  );

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadFieldSchedules();
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

  void _loadFieldSchedules() {
    context.read<FieldReservationBloc>().add(
          LoadFieldSchedules(fieldType: widget.fieldType.name),
        );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _fieldPageController.dispose();
    super.dispose();
  }

  void _selectField(int index) {
    if (index < fieldSchedules.length) {
      setState(() {
        selectedFieldIndex = index;
        selectedField = fieldSchedules[index];
        // Reset selections when field changes
        selectedDate = null;
        selectedTimeSlotId = null;
        selectedTimeSlot = null;
      });
    }
  }

  void _selectDate(String date) {
    setState(() {
      selectedDate = date;
      // Reset time selection when date changes
      selectedTimeSlotId = null;
      selectedTimeSlot = null;
    });
  }

  void _selectTimeSlot(AvailableTimeSlot timeSlot) {
    if (timeSlot.isAvailable) {
      setState(() {
        selectedTimeSlotId = timeSlot.timeSlotId;
        selectedTimeSlot = timeSlot;
      });
    }
  }

  void _makeReservation() {
    if (selectedField != null &&
        selectedDate != null &&
        selectedTimeSlotId != null) {
      final request = ReservationRequest(
        fieldId: selectedField!.fieldId,
        date: selectedDate!,
        timeSlotId: selectedTimeSlotId!,
      );
      context.read<FieldReservationBloc>().add(
            MakeFieldReservation(request: request),
          );
    }
  }

  List<AvailableDate> _getAvailableDatesForSelectedField() {
    if (selectedField != null) {
      return selectedField!.availableDates;
    }
    return [];
  }

  List<AvailableTimeSlot> _getAvailableTimeSlotsForSelectedDate() {
    if (selectedField != null && selectedDate != null) {
      final availableDate = selectedField!.availableDates.firstWhere(
        (date) => date.date == selectedDate,
        orElse: () => const AvailableDate(
          date: '',
          dayName: '',
          day: '',
          month: '',
          availableTimeSlots: [],
        ),
      );
      return availableDate.availableTimeSlots;
    }
    return [];
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.overlayColor,
                AppTheme.primaryColor.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.overlayColor.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.accentColor,
                    width: 3,
                  ),
                  color: AppTheme.accentColor.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.check,
                  color: AppTheme.accentColor,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'RÉSERVATION EFFECTUÉE',
                  style: TextStyle(
                    color: AppTheme.primaryTextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'AVEC SUCCÈS',
                  style: TextStyle(
                    color: AppTheme.primaryTextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pour consulter, veuillez vérifier votre\nhistorique de réservations',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: AppTheme.primaryTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Continuer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.home_background),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
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
          child: SafeArea(
            child: BlocListener<FieldReservationBloc, FieldReservationState>(
              listener: (context, state) {
                if (state is FieldSchedulesLoaded) {
                  setState(() {
                    fieldSchedules = state.schedules;
                    if (fieldSchedules.isNotEmpty) {
                      selectedField = fieldSchedules[0];
                    }
                  });
                } else if (state is ReservationMade) {
                  _showSuccessDialog();
                } else if (state is FieldSchedulesError) {
                  _showErrorSnackBar(
                      'Failed to load field schedules: ${state.message}');
                } else if (state is ReservationError) {
                  _showErrorSnackBar(
                      'Failed to make reservation: ${state.message}');
                }
              },
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.width * 0.05,
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                _buildHeader(context),
                                SizedBox(height: context.height * 0.02),
                                _buildTitle(),
                                SizedBox(height: context.height * 0.025),
                                _buildContent(context),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<FieldReservationBloc, FieldReservationState>(
      builder: (context, state) {
        if (state is FieldSchedulesLoading) {
          return _buildLoadingState();
        } else if (state is FieldSchedulesError) {
          return _buildErrorState(state.message);
        } else if (fieldSchedules.isEmpty) {
          return _buildEmptyState();
        } else {
          return Column(
            children: [
              _buildFieldSection(context),
              SizedBox(height: context.height * 0.02),
              _buildDateSection(context),
              SizedBox(height: context.height * 0.02),
              _buildTimeSection(context),
              SizedBox(height: context.height * 0.04),
              _buildReserveButton(context),
            ],
          );
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
            ),
            SizedBox(height: 16),
            Text(
              'Chargement des terrains...',
              style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'Erreur lors du chargement',
              style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFieldSchedules,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.primaryTextColor,
              ),
              child: Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_soccer,
              color: AppTheme.secondaryTextColor,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'Aucun terrain disponible',
              style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Veuillez réessayer plus tard',
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.primaryTextColor,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'Retourner',
                      style: TextStyle(
                        color: AppTheme.primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Profile avatar
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.borderColor,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
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

  Widget _buildTitle() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        widget.fieldType.displayName,
        style: TextStyle(
          color: AppTheme.primaryTextColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFieldSection(BuildContext context) {
    final fieldHeight = context.height * 0.22;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choisir Votre Terrain',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.height * 0.015),
        SizedBox(
          height: fieldHeight,
          child: Stack(
            children: [
              // PageView for fields
              PageView.builder(
                controller: _fieldPageController,
                itemCount: fieldSchedules.length,
                onPageChanged: _selectField, // Updated to _selectField
                itemBuilder: (context, index) {
                  final isSelected = index == selectedFieldIndex;
                  final field =
                      fieldSchedules[index]; // Changed from static fields list

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    transform: Matrix4.identity()
                      ..scale(isSelected ? 1.0 : 0.85),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isSelected ? 1.0 : 0.6,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.borderColor
                                : AppTheme.borderColor.withOpacity(0.3),
                            width: isSelected ? 3 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.overlayColor
                                  .withOpacity(isSelected ? 0.4 : 0.2),
                              blurRadius: isSelected ? 15 : 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Stack(
                            children: [
                              // Field background
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: widget.fieldType == Field.soccer
                                        ? [
                                            Colors.green.shade400,
                                            Colors.green.shade600,
                                          ]
                                        : [
                                            Colors.orange.shade400,
                                            Colors.orange.shade600,
                                          ],
                                  ),
                                ),
                              ),
                              // Field lines overlay
                              SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: CustomPaint(
                                  painter:
                                      SoccerFieldPainter(), // Assuming this painter is defined elsewhere or will be provided
                                ),
                              ),
                              // Field name
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.8),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          field.fieldName, // Dynamic field name
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                        ),
                                      ),
                                      if (field.location
                                          .isNotEmpty) // Dynamic location
                                        Text(
                                          field.location,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      if (isSelected)
                                        Container(
                                          margin: const EdgeInsets.only(top: 4),
                                          width: 40,
                                          height: 2,
                                          decoration: BoxDecoration(
                                            color: AppTheme.accentColor,
                                            borderRadius:
                                                BorderRadius.circular(1),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (fieldSchedules.length > 1) ...[
                // Only show arrows if more than one field
                _buildNavigationArrow(
                  isLeft: true,
                  isVisible: selectedFieldIndex > 0,
                  onTap: () => _fieldPageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
                _buildNavigationArrow(
                  isLeft: false,
                  isVisible: selectedFieldIndex < fieldSchedules.length - 1,
                  onTap: () => _fieldPageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationArrow({
    required bool isLeft,
    required bool isVisible,
    required VoidCallback onTap,
  }) {
    return Positioned(
      left: isLeft ? 0 : null,
      right: isLeft ? null : 0,
      top: 0,
      bottom: 0,
      child: Center(
        child: isVisible
            ? GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.overlayColor.withOpacity(0.8),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.borderColor.withOpacity(0.5),
                    ),
                  ),
                  child: Icon(
                    isLeft ? Icons.chevron_left : Icons.chevron_right,
                    color: AppTheme.primaryTextColor,
                    size: 24,
                  ),
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  Widget _buildDateSection(BuildContext context) {
    final availableDates =
        _getAvailableDatesForSelectedField(); // Dynamic dates
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choisir Votre Date',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.height * 0.015),
        if (availableDates.isEmpty)
          Container(
            height: 80,
            child: Center(
              child: Text(
                'Aucune date disponible',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableDates.length,
              itemBuilder: (context, index) {
                final availableDate = availableDates[index];
                final isSelected = availableDate.date == selectedDate;
                return GestureDetector(
                  onTap: () => _selectDate(availableDate.date),
                  child: Container(
                    margin: EdgeInsets.only(right: context.width * 0.02),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    constraints: const BoxConstraints(minWidth: 70),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accentColor
                          : AppTheme.cardColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.borderColor
                            : AppTheme.borderColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            availableDate.dayName,
                            style: TextStyle(
                              color: isSelected
                                  ? AppTheme.primaryTextColor
                                  : AppTheme.secondaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          availableDate.day,
                          style: TextStyle(
                            color: isSelected
                                ? AppTheme.primaryTextColor
                                : AppTheme.secondaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            availableDate.month,
                            style: TextStyle(
                              color: isSelected
                                  ? AppTheme.primaryTextColor
                                  : AppTheme.secondaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
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
    );
  }

  Widget _buildTimeSection(BuildContext context) {
    final availableTimeSlots = _getAvailableTimeSlotsForSelectedDate();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choisir Votre Créneau',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.height * 0.015),
        if (selectedDate == null)
          Container(
            height: 60,
            child: Center(
              child: Text(
                'Veuillez d\'abord choisir une date',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else if (availableTimeSlots.isEmpty)
          Container(
            height: 60,
            child: Center(
              child: Text(
                'Aucun créneau disponible pour cette date',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableTimeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = availableTimeSlots[index];
                final isSelected = timeSlot.timeSlotId == selectedTimeSlotId;
                final isAvailable = timeSlot.isAvailable;

                return GestureDetector(
                  onTap: isAvailable ? () => _selectTimeSlot(timeSlot) : null,
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    constraints: const BoxConstraints(minWidth: 90),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accentColor
                          : isAvailable
                              ? AppTheme.cardColor.withOpacity(0.3)
                              : AppTheme.cardColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.borderColor
                            : isAvailable
                                ? AppTheme.borderColor.withOpacity(0.3)
                                : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        timeSlot.startTime,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryTextColor
                              : isAvailable
                                  ? AppTheme.secondaryTextColor
                                  : AppTheme.secondaryTextColor
                                      .withOpacity(0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildReserveButton(BuildContext context) {
    final bool isButtonEnabled = selectedField != null &&
        selectedDate != null &&
        selectedTimeSlotId != null;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isButtonEnabled ? _makeReservation : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: AppTheme.primaryTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Réserver Maintenant',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SoccerFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);

    
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width * 0.15, paint);

    
    canvas.drawRect(
        Rect.fromLTWH(0, size.height / 4, size.width * 0.15, size.height / 2),
        paint);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.85, size.height / 4, size.width * 0.15,
            size.height / 2),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
