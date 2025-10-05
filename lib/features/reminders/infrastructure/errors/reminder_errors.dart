
class ReminderError implements Exception {
  final String message;
  ReminderError(this.message);
  @override String toString()=> 'ReminderError: \$message';
}
