import 'package:intl/intl.dart';
import 'package:rrule/rrule.dart';

class DateUtilsHelper {
  static String formatDateTime(DateTime dt) =>
      DateFormat('yyyy-MM-dd HH:mm').format(dt);

  /// Devuelve las próximas [count] ocurrencias de una regla RRULE
  static List<DateTime> occurrencesFromRRule(
    String rruleString, {
    required DateTime start,
    int count = 5,
  }) {
    try {
      final rule = RecurrenceRule.fromString(rruleString);
      
      // Usamos el parámetro 'after' para obtener instancias después de la fecha de inicio
      final instances = rule
          .getInstances(
            start: start.toUtc(), // 👈 requerido
            after: start.toUtc(), // 👈 obtener instancias después de esta fecha
            includeAfter: false,  // 👈 no incluir la fecha exacta
          )
          .take(count) // 👈 tomar solo los primeros 'count' elementos
          .map((e) => e.toLocal())
          .toList();
      return instances;
    } catch (e) {
      print("Error parsing RRULE: $e");
      return [];
    }
  }
}