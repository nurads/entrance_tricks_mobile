import 'package:get/get.dart';
import 'package:vector_academy/models/models.dart';
import 'package:vector_academy/services/api/user_results.dart';
import 'package:vector_academy/services/api/leaderboard.dart';
import 'package:vector_academy/utils/storages/storages.dart';
import 'package:vector_academy/utils/device/device.dart';
import 'package:vector_academy/utils/utils.dart';

class UserScoreController extends GetxController {
  final UserResultsService _userResultsService = UserResultsService();
  final LeaderboardService _leaderboardService = LeaderboardService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingCompetitions = false;
  bool get isLoadingCompetitions => _isLoadingCompetitions;

  String? _error;
  String? get error => _error;

  List<Map<String, dynamic>> _competitions = [];
  List<Map<String, dynamic>> get competitions => _competitions;

  int? _selectedCompetitionId;
  int? get selectedCompetitionId => _selectedCompetitionId;

  UserLeaderboardResult? _userResult;
  UserLeaderboardResult? get userResult => _userResult;

  User? _user;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoadingCompetitions = true;
    _error = null;
    update(); // Notify UI of loading state

    try {
      _user = await HiveUserStorage().getUser();
      // Load competitions without blocking - don't auto-load user results
      await loadCompetitions();
      HiveUserStorage().listen((event) {
        _user = event;
        loadCompetitions();
      }, 'user');
    } catch (e) {
      logger.e('Failed to initialize UserScoreController: $e');
      _error = 'Failed to initialize. Please try again.';
      _isLoadingCompetitions = false;
      update(); // Notify UI of error state
    }
  }

  Future<void> loadCompetitions() async {
    // Prevent multiple simultaneous loads
    _isLoadingCompetitions = true;
    _error = null;
    _competitions = []; // Clear old competitions
    _selectedCompetitionId = null; // Reset selection
    _userResult = null; // Clear old results
    update(); // Notify UI immediately

    try {
      final phoneNumber = _user?.phoneNumber;
      if (phoneNumber == null || phoneNumber.isEmpty) {
        logger.w('loadCompetitions: No phone number available');
        _competitions = [];
        _isLoadingCompetitions = false;
        update();
        return;
      }

      final device = await UserDevice.getDeviceInfo(phoneNumber);
      final competitions = await _leaderboardService.getAvailableCompetitions(
        device.id,
      );

      // Filter out competitions with invalid IDs
      _competitions = competitions.where((comp) {
        final id = comp['id'];
        return id != null && id is int;
      }).toList();

      logger.i('Loaded ${_competitions.length} competitions');
    } catch (e) {
      logger.e('Failed to load competitions: $e');
      _competitions = [];
      _error = 'Failed to load competitions. Please try again.';
    } finally {
      _isLoadingCompetitions = false;
      update(); // Notify UI of completion
    }
  }

  void selectCompetition(int? competitionId) {
    if (_selectedCompetitionId == competitionId) {
      logger.i('selectCompetition: Already selected, skipping');
      return; // Already selected
    }

    // Validate competition ID exists in the list
    if (competitionId != null) {
      final exists = _competitions.any((comp) => comp['id'] == competitionId);
      if (!exists) {
        logger.w(
          'selectCompetition: Competition ID $competitionId not found in list',
        );
        return;
      }
    }

    logger.i('selectCompetition: Selecting competition $competitionId');
    _selectedCompetitionId = competitionId;
    _userResult = null; // Clear old results
    _error = null; // Clear old errors
    _isLoading = false; // Reset loading state
    update(); // Update UI immediately with new selection

    if (competitionId != null) {
      // Load results in background without blocking UI
      loadUserResult();
    }
  }

  Future<void> loadUserResult() async {
    if (_selectedCompetitionId == null) {
      logger.w('loadUserResult: No competition selected');
      return;
    }

    // Prevent loading if already loading
    if (_isLoading) {
      logger.w('loadUserResult: Already loading, skipping');
      return;
    }

    logger.i(
      'loadUserResult: Loading results for competition $_selectedCompetitionId',
    );
    _isLoading = true;
    _error = null;
    _userResult = null; // Clear old data
    update(); // Notify UI of loading state

    try {
      final result = await _userResultsService.getUserLeaderboardResult(
        _selectedCompetitionId!,
      );

      if (result == null) {
        logger.w('loadUserResult: No results found');
        _error = 'No results found for this competition';
        _userResult = null;
      } else {
        logger.i('loadUserResult: Successfully loaded results');
        _userResult = result;
        _error = null;
      }
    } catch (e) {
      logger.e('Failed to load user result: $e');
      _error = 'Failed to load results. Please try again.';
      _userResult = null;
    } finally {
      _isLoading = false;
      update(); // Notify UI of completion
    }
  }

  Future<void> refreshResults() async {
    await loadUserResult();
  }
}
