import 'package:flutter/material.dart';
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';
import '../../../../core/theme/theme.dart';
import '../../../reserve_field/domain/entities/field_schedule.dart';
import '../../domain/entities/match.dart';

class MatchManagementScreen extends StatefulWidget {
  final Field fieldType;

  const MatchManagementScreen({
    super.key,
    required this.fieldType,
  });

  @override
  State<MatchManagementScreen> createState() => _MatchManagementScreenState();
}

class _MatchManagementScreenState extends State<MatchManagementScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  late List<OpenMatch> _openMatches;

  // Add a FocusNode for the screen itself
  final FocusNode _screenFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadOpenMatches();
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

  void _loadOpenMatches() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _openMatches = _generateMockMatches();
        _isLoading = false;
      });
    });
  }

  List<OpenMatch> _generateMockMatches() {
    if (widget.fieldType == Field.soccer) {
      return [
        const OpenMatch(
          matchId: 'match_1',
          fieldType: 'soccer',
          fieldName: 'Terrain de Foot 1',
          date: '2025-07-20',
          time: '14:00 - 15:00',
          creatorName: 'Ahmed M.',
          totalSeats: 22,
          availableSeats: 8,
          pricePerSeat: 25.0,
          location: 'Centre Sportif A',
        ),
        const OpenMatch(
          matchId: 'match_2',
          fieldType: 'soccer',
          fieldName: 'Terrain de Foot 2',
          date: '2025-07-21',
          time: '16:00 - 17:00',
          creatorName: 'Karim B.',
          totalSeats: 22,
          availableSeats: 12,
          pricePerSeat: 30.0,
          location: 'Centre Sportif B',
        ),
        const OpenMatch(
          matchId: 'match_3',
          fieldType: 'soccer',
          fieldName: 'Terrain de Foot 1',
          date: '2025-07-22',
          time: '18:00 - 19:00',
          creatorName: 'Youssef K.',
          totalSeats: 22,
          availableSeats: 0,
          pricePerSeat: 35.0,
          location: 'Centre Sportif A',
        ),
      ];
    } else {
      return [
        const OpenMatch(
          matchId: 'padel_match_1',
          fieldType: 'padel',
          fieldName: 'Court de Padel 1',
          date: '2025-07-20',
          time: '15:00 - 16:00',
          creatorName: 'Sofiane A.',
          totalSeats: 4,
          availableSeats: 2,
          pricePerSeat: 20.0,
          location: 'Club de Padel X',
        ),
        const OpenMatch(
          matchId: 'padel_match_2',
          fieldType: 'padel',
          fieldName: 'Court de Padel 2',
          date: '2025-07-21',
          time: '17:00 - 18:00',
          creatorName: 'Rania L.',
          totalSeats: 4,
          availableSeats: 1,
          pricePerSeat: 25.0,
          location: 'Club de Padel Y',
        ),
      ];
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    _screenFocusNode.dispose(); // Dispose the FocusNode
    super.dispose();
  }

  void _joinMatch(OpenMatch match) {
    if (match.isFull) return;

    showDialog(
      context: context,
      builder: (context) => _buildJoinMatchDialog(match),
    );
  }

  void _searchPrivateMatch() {
    final link = _searchController.text.trim();
    if (link.isEmpty) {
      _showErrorSnackBar('Veuillez entrer un lien de match');
      return;
    }

    _showLoadingDialog('Recherche du match...');

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();

      if (link.contains('match')) {
        _showSuccessSnackBar('Match trouvé! Rejoindre le match...');
      } else {
        _showErrorSnackBar('Match non trouvé. Vérifiez le lien.');
      }
      // Ensure focus is removed after search operation
      FocusScope.of(context).unfocus();
    });
  }

  void _createNewMatch() {
    Navigator.of(context).pushNamed(
      '/reserve_field',
      arguments: widget.fieldType,
    );
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              ),
              const SizedBox(width: 16),
              Text(
                message,
                style: TextStyle(
                  color: AppTheme.primaryTextColor,
                  fontSize: 16,
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
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(context.width * 0.02),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(context.width * 0.02),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // When tapping anywhere on the screen, unfocus everything
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        // Assign the FocusNode to the outermost Focus widget
        body: Focus(
          focusNode: _screenFocusNode,
          child: Container(
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
                          _buildSearchSection(context),
                          SizedBox(height: context.height * 0.02),
                          _buildCreateMatchButton(context),
                          SizedBox(height: context.height * 0.02),
                          _buildOpenMatchesSection(context),
                        ],
                      ),
                    ),
                  ),
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
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            FocusScope.of(context).unfocus(); // Ensure unfocus on back button
          },
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
                Text(
                  'Retour',
                  style: TextStyle(
                    color: AppTheme.primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
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
    return Column(
      children: [
        Text(
          widget.fieldType == Field.soccer
              ? 'Matchs de Football'
              : 'Matchs de Padel',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Rejoignez un match ou créez le vôtre',
          style: TextStyle(
            color: AppTheme.secondaryTextColor,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Match Privé',
            style: TextStyle(
              color: AppTheme.primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: AppTheme.primaryTextColor),
                  decoration: InputDecoration(
                    hintText: 'Entrez le lien du match privé',
                    hintStyle: TextStyle(
                      color: AppTheme.secondaryTextColor.withOpacity(0.7),
                    ),
                    filled: true,
                    fillColor: AppTheme.cardColor.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _searchPrivateMatch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: AppTheme.primaryTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Text('Rechercher'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateMatchButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _createNewMatch,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: AppTheme.primaryTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        icon: Icon(
          Icons.add_circle_outline,
          size: 24,
          color: AppTheme.primaryTextColor,
        ),
        label: Text(
          'Créer un Nouveau Match',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOpenMatchesSection(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Matchs Ouverts',
            style: TextStyle(
              color: AppTheme.primaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _openMatches.isEmpty
                    ? _buildEmptyState()
                    : _buildMatchesList(),
          ),
        ],
      ),
    );
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
            'Chargement des matchs...',
            style: TextStyle(
              color: AppTheme.primaryTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.fieldType == Field.soccer
                ? Icons.sports_soccer
                : Icons.sports_tennis,
            color: AppTheme.secondaryTextColor,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun match ouvert',
            style: TextStyle(
              color: AppTheme.primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Soyez le premier à créer un match!',
            style: TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesList() {
    return ListView.builder(
      itemCount: _openMatches.length,
      itemBuilder: (context, index) {
        final match = _openMatches[index];
        return _buildMatchCard(match);
      },
    );
  }

  Widget _buildMatchCard(OpenMatch match) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.cardColor.withOpacity(0.8),
            AppTheme.secondaryColor.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.overlayColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.fieldName,
                        style: TextStyle(
                          color: AppTheme.primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        match.location,
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: match.isFull
                        ? Colors.red.withOpacity(0.2)
                        : AppTheme.accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: match.isFull ? Colors.red : AppTheme.accentColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    match.isFull ? 'Complet' : '${match.availableSeats} places',
                    style: TextStyle(
                      color: match.isFull ? Colors.red : AppTheme.accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.secondaryTextColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  match.date,
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  color: AppTheme.secondaryTextColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  match.time,
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: AppTheme.secondaryTextColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Créé par ${match.creatorName}',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '${match.pricePerSeat.toStringAsFixed(0)} DA',
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: match.isFull ? null : () => _joinMatch(match),
                style: ElevatedButton.styleFrom(
                  backgroundColor: match.isFull
                      ? AppTheme.secondaryTextColor.withOpacity(0.3)
                      : AppTheme.accentColor,
                  foregroundColor: AppTheme.primaryTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  match.isFull ? 'Match Complet' : 'Rejoindre le Match',
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
    );
  }

  Widget _buildJoinMatchDialog(OpenMatch match) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(context.width * 0.02),
        padding: EdgeInsets.all(context.width * 0.02),
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
            Text(
              'Rejoindre le Match',
              style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              match.fieldName,
              style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${match.date} • ${match.time}',
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.height * 0.02),
            Container(
              padding: EdgeInsets.all(context.width * 0.05),
              decoration: BoxDecoration(
                color: AppTheme.cardColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.borderColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prix par place:',
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${match.pricePerSeat.toStringAsFixed(0)} DA',
                        style: TextStyle(
                          color: AppTheme.accentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Places disponibles:',
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${match.availableSeats}/${match.totalSeats}',
                        style: TextStyle(
                          color: AppTheme.primaryTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: context.height * 0.02),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // After popping the dialog, request focus to the screen's FocusNode
                      FocusScope.of(context).requestFocus(_screenFocusNode);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.secondaryTextColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: context.width * 0.02),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showSuccessSnackBar(
                          'Demande envoyée! Vous serez contacté bientôt.');
                      // After popping the dialog, request focus to the screen's FocusNode
                      FocusScope.of(context).requestFocus(_screenFocusNode);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: AppTheme.primaryTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Rejoindre',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
