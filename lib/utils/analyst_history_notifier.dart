import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/model/analyst_history_model.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/utils/analyst_history_service.dart';

class AnalystHistoryNotifier extends StateNotifier<AsyncValue<AnalystHistoryResponse>> {
  AnalystHistoryNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchHistory();
  }

  final Ref ref;

  Future<void> fetchHistory() async {
    try {
      final user = ref.read(userProvider);
      if (user != null) {
        final history = await ref.read(analystHistoryProvider).fetchHistory(user.token);
        state = AsyncValue.data(history);
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final analystHistoryNotifierProvider =
    StateNotifierProvider<AnalystHistoryNotifier, AsyncValue<AnalystHistoryResponse>>((ref) {
  return AnalystHistoryNotifier(ref);
});

/*import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/model/analyst_history_model.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/utils/analyst_history_service.dart';



class AnalystHistoryNotifier extends StateNotifier<AsyncValue<AnalystHistoryData>> {
  final Ref ref;

  AnalystHistoryNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
        final user = ref.read(userProvider);
      if (user != null) {
             final history = await ref.read(analystHistoryServiceProvider).fetchHistory(user.token);
        state = AsyncValue.data(history);
      } else {
        throw Exception("User not logged in");
      }
    }catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final analystHistoryNotifierProvider = StateNotifierProvider<AnalystHistoryNotifier, AsyncValue<AnalystHistoryData>>((ref) {
  return AnalystHistoryNotifier(ref);
});
*/


