import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reminders_app/features/reminders/domain/domain.dart';

class RemoteReminderDatasourceImpl extends RemoteReminderDatasource {
  final FirebaseFirestore firestore;

  RemoteReminderDatasourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection('reminders');

  @override
  Future<List<Reminder>> loadAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => Reminder.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<void> add(Reminder reminder) async {
    await _collection.doc(reminder.id).set(reminder.toMap());
  }

  @override
  Future<void> update(Reminder reminder) async {
    await _collection.doc(reminder.id).update(reminder.toMap());
  }

  @override
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}