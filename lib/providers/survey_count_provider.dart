import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/utils/database_service.dart';


final surveyCountProvider = StateNotifierProvider<SurveyCountNotifier, int>((ref) {
  return SurveyCountNotifier();
});

class SurveyCountNotifier extends StateNotifier<int> {
  SurveyCountNotifier() : super(0) {
    _fetchSurveyCount();
  }

  Future<void> _fetchSurveyCount() async {
    final dbHelper = DatabaseHelper();
    final count = await dbHelper.getSurveyCount();
    state = count;
  }

  Future<void> refreshSurveyCount() async {
    await _fetchSurveyCount();
  }
}
