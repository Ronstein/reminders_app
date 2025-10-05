import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminders_app/features/reminders/domain/domain.dart';
import 'package:reminders_app/features/reminders/presentation/providers/providers.dart';


final remindersListProvider = AsyncNotifierProvider<RemindersNotifier, List<Reminder>>(() => RemindersNotifier());

class RemindersNotifier extends AsyncNotifier<List<Reminder>> {
  late final ReminderRepository _repo;

  @override
  Future<List<Reminder>> build() async {
    _repo = ref.read(remindersRepositoryProvider);
    final list = await _repo.loadAll();
    return list;
  }

  Future<void> addReminder(Reminder r) async {
    state = const AsyncValue.loading();
    await _repo.add(r);
    state = AsyncValue.data(await _repo.loadAll());
  }

  Future<void> updateReminder(Reminder r) async {
    state = const AsyncValue.loading();
    await _repo.update(r);
    state = AsyncValue.data(await _repo.loadAll());
  }

  Future<void> deleteReminder(String id) async {
    state = const AsyncValue.loading();
    await _repo.delete(id);
    state = AsyncValue.data(await _repo.loadAll());
  }

  Reminder? getById(String id) {
    return state.value?.firstWhere((r) => r.id == id);
  }
}
