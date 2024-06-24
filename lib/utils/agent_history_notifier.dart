import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/model/agent_history_model.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/utils/agent_history_service.dart';

class HistoryNotifier extends StateNotifier<AsyncValue<HistoryResponse>> {
  HistoryNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchHistory();
  }

  final Ref ref;

  Future<void> fetchHistory() async {
    try {
      final user = ref.read(userProvider);
      if (user != null) {
        final history = await ref.read(historyProvider).fetchHistory(user.token);
        state = AsyncValue.data(history);
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      state = AsyncValue.error(e,StackTrace.current);
    }
  }
}

final historyNotifierProvider =
    StateNotifierProvider<HistoryNotifier, AsyncValue<HistoryResponse>>((ref) {
  return HistoryNotifier(ref);
});

