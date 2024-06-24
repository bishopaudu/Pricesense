// coordinator_history_notifier.dart
/*import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/model/coordinator_history_model.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/utils/coordinator_history_service.dart';

class CoordinatorHistoryNotifier extends StateNotifier<AsyncValue<EnergyHistoryModel>> {
  CoordinatorHistoryNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchHistory();
  }

  final Ref ref;

  Future<void> fetchHistory() async {
    try {
      final user = ref.read(userProvider);
      if (user != null) {
        final history = await ref.read(coordinatorHistoryProvider).fetchHistory(user.token);
        state = AsyncValue.data(history);
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final coordinatorHistoryProvider = Provider<CoordinatorHistoryService>((ref) => CoordinatorHistoryService());

final coordinatorHistoryNotifierProvider =
    StateNotifierProvider<CoordinatorHistoryNotifier, AsyncValue<EnergyHistoryModel>>((ref) {
  return CoordinatorHistoryNotifier(ref);
});*/

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/model/coordinator_history_model.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/utils/coordinator_history_service.dart';

class CoordinatorHistoryNotifier extends StateNotifier<AsyncValue<EnergyHistoryModel>> {
  CoordinatorHistoryNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchHistory();
  }

  final Ref ref;

  Future<void> fetchHistory() async {
    try {
      final user = ref.read(userProvider);
      if (user != null) {
        final history = await ref.read(coordinatorHistoryProvider).fetchHistory(user.token);
        state = AsyncValue.data(history);
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

final coordinatorHistoryProvider = Provider<CoordinatorHistoryService>((ref) => CoordinatorHistoryService());

final coordinatorHistoryNotifierProvider =
    StateNotifierProvider<CoordinatorHistoryNotifier, AsyncValue<EnergyHistoryModel>>((ref) {
  return CoordinatorHistoryNotifier(ref);
});

