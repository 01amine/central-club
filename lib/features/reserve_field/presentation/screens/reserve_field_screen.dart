import 'package:flutter/material.dart';
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/field.dart';

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

  List<TimeSlot> timeSlots = [];
  List<DateSlot> dateSlots = getDateSlots();
  int selectedFieldIndex = 0;
  String? selectedTime;
  String? selectedDate;

  final PageController _fieldPageController = PageController(
    viewportFraction: 0.7,
  );

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

    _fadeController.forward();
    _slideController.forward();

    timeSlots = getTimeSlots();

    selectedTime = '9:30';
    selectedDate = dateSlots.first.fullDate;

    timeSlots = timeSlots.map((slot) {
      return slot.copyWith(isSelected: slot.time == selectedTime);
    }).toList();

    dateSlots = dateSlots.map((slot) {
      return slot.copyWith(isSelected: slot.fullDate == selectedDate);
    }).toList();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _fieldPageController.dispose();
    super.dispose();
  }

  void _selectTime(String time) {
    setState(() {
      selectedTime = time;
      timeSlots = timeSlots.map((slot) {
        return slot.copyWith(isSelected: slot.time == time);
      }).toList();
    });
  }

  void _selectDate(String date) {
    setState(() {
      selectedDate = date;
      dateSlots = dateSlots.map((slot) {
        return slot.copyWith(isSelected: slot.fullDate == date);
      }).toList();
    });
  }

  void _makeReservation() {
    if (selectedTime != null && selectedDate != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _buildSuccessDialog(),
      );

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    }
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
                              // Header
                              _buildHeader(context),

                              SizedBox(height: context.height * 0.02),

                              // Title
                              _buildTitle(),

                              SizedBox(height: context.height * 0.025),

                              // Field selection wheel
                              _buildFieldSection(context),

                              SizedBox(height: context.height * 0.02),

                              // Date selection
                              _buildDateSection(context),

                              SizedBox(height: context.height * 0.02),

                              // Time selection
                              _buildTimeSection(context),

                              SizedBox(height: context.height * 0.04),

                              // Reserve button
                              _buildReserveButton(context),

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
    final fields = [
      {'name': 'Terrain Central', 'type': 'Central'},
      {'name': 'Terrain Est', 'type': 'Est'},
      {'name': 'Terrain Ouest', 'type': 'Ouest'},
    ];

    final fieldHeight = context.height * 0.22;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choisir Votre Type de Terrain',
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
                itemCount: fields.length,
                onPageChanged: (index) {
                  setState(() {
                    selectedFieldIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final isSelected = index == selectedFieldIndex;
                  final field = fields[index];

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
                                  painter: SoccerFieldPainter(),
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
                                          'Réservation ${field['name']}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                        ),
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

              // Left arrow
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: selectedFieldIndex > 0
                      ? GestureDetector(
                          onTap: () {
                            _fieldPageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
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
                              Icons.chevron_left,
                              color: AppTheme.primaryTextColor,
                              size: 24,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),

              // Right arrow
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: selectedFieldIndex < fields.length - 1
                      ? GestureDetector(
                          onTap: () {
                            _fieldPageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
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
                              Icons.chevron_right,
                              color: AppTheme.primaryTextColor,
                              size: 24,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection(BuildContext context) {
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
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dateSlots.length,
            itemBuilder: (context, index) {
              final dateSlot = dateSlots[index];
              final isSelected = dateSlot.isSelected;

              return GestureDetector(
                onTap: () => _selectDate(dateSlot.fullDate),
                child: Container(
                  margin: EdgeInsets.only(right: context.width * 0.02),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 70,
                  ),
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
                          dateSlot.dayName,
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
                        dateSlot.day,
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
                          dateSlot.month,
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
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              final timeSlot = timeSlots[index];
              final isSelected = timeSlot.isSelected;

              return GestureDetector(
                onTap: () => _selectTime(timeSlot.time),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 80,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accentColor
                        : AppTheme.cardColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.borderColor
                          : AppTheme.borderColor.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        timeSlot.time,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryTextColor
                              : AppTheme.secondaryTextColor,
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
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
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (selectedTime != null && selectedDate != null)
            ? _makeReservation
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: AppTheme.primaryTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 8,
          shadowColor: AppTheme.overlayColor.withOpacity(0.5),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'RÉSERVER',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessDialog() {
    return Dialog(
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
                  color: AppTheme.primaryTextColor,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.check,
                color: AppTheme.primaryTextColor,
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
          ],
        ),
      ),
    );
  }
}

class SoccerFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(rect, paint);

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height * 0.2,
      paint,
    );

    final goalWidth = size.width * 0.3;
    final goalHeight = size.height * 0.4;

    canvas.drawRect(
      Rect.fromLTWH(
          0, (size.height - goalHeight) / 2, goalWidth / 2, goalHeight),
      paint,
    );

    canvas.drawRect(
      Rect.fromLTWH(size.width - goalWidth / 2, (size.height - goalHeight) / 2,
          goalWidth / 2, goalHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DateSlot {
  final String dayName;
  final String day;
  final String month;
  final String fullDate;
  final bool isSelected;

  DateSlot({
    required this.dayName,
    required this.day,
    required this.month,
    required this.fullDate,
    this.isSelected = false,
  });

  DateSlot copyWith({
    String? dayName,
    String? day,
    String? month,
    String? fullDate,
    bool? isSelected,
  }) {
    return DateSlot(
      dayName: dayName ?? this.dayName,
      day: day ?? this.day,
      month: month ?? this.month,
      fullDate: fullDate ?? this.fullDate,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

List<DateSlot> getDateSlots() {
  final now = DateTime.now();
  final dates = <DateSlot>[];

  for (int i = 0; i < 7; i++) {
    final date = now.add(Duration(days: i));
    final dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final monthNames = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ];

    dates.add(DateSlot(
      dayName: dayNames[date.weekday - 1],
      day: date.day.toString().padLeft(2, '0'),
      month: monthNames[date.month - 1],
      fullDate:
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
    ));
  }

  return dates;
}

// Mock TimeSlot class for reference
class TimeSlot {
  final String time;
  final bool isSelected;

  TimeSlot({
    required this.time,
    this.isSelected = false,
  });

  TimeSlot copyWith({
    String? time,
    bool? isSelected,
  }) {
    return TimeSlot(
      time: time ?? this.time,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

// Mock function for getting time slots
List<TimeSlot> getTimeSlots() {
  return [
    TimeSlot(time: '8:00'),
    TimeSlot(time: '9:30'),
    TimeSlot(time: '11:00'),
    TimeSlot(time: '14:00'),
    TimeSlot(time: '15:30'),
    TimeSlot(time: '17:00'),
    TimeSlot(time: '18:30'),
    TimeSlot(time: '20:00'),
  ];
}
