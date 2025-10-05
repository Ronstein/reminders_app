import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reminders_app/features/auth/presentation/providers/providers.dart';
import 'package:reminders_app/features/reminders/domain/domain.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart'; 

class RemindersScreen extends ConsumerStatefulWidget {
  static const String name = 'Recordatorios';
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  ReminderFilter _filter = ReminderFilter.all; // <- filtro inicial

  @override
  Widget build(BuildContext context) {
    final remindersAsync = ref.watch(remindersListProvider);

    String getFilterLabel() {
      switch (_filter) {
        case ReminderFilter.pending:
          return 'Pendientes';
        case ReminderFilter.completed:
          return 'Completados';
        case ReminderFilter.skipped:
          return 'Omitidos';
        default:
          return 'Todos';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Recordatorios (${getFilterLabel()})'),
        leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        actions: [
          RemindersFilter(
            selected: _filter,
            onChanged: (value) {
              setState(() {
                _filter = value; // Actualiza el filtro
              });
            },
          ),
        ],
      ),
      body: remindersAsync.when(
        data: (items) {
          // 🔹 Filtrar usando ReminderFilter
          final filtered = (_filter == ReminderFilter.all)
              ? items
              : items.where((r) {
                  switch (_filter) {
                    case ReminderFilter.pending:
                      return r.state == ReminderState.pending;
                    case ReminderFilter.completed:
                      return r.state == ReminderState.completed;
                    case ReminderFilter.skipped:
                      return r.state == ReminderState.skipped;
                    default:
                      return true;
                  }
                }).toList();

          // 🔹 Ordenar por fecha y estado
          filtered.sort((a, b) {
            final dateCompare = a.dateTime.compareTo(b.dateTime);
            if (dateCompare != 0) return dateCompare;
            return a.state.index.compareTo(b.state.index);
          });

          if (filtered.isEmpty) {
            return const Center(child: Text('No hay recordatorios.'));
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, i) => ReminderCard(reminder: filtered[i]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
