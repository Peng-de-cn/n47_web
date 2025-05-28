import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/event.dart';
import '../database/event_repository.dart';
import '../firebase/fire_store.dart';
import '../utils/logger_util.dart';

class FutureEventsCubit extends Cubit<List<Event>> {

  FutureEventsCubit() : super([]);

  Future<void> initializeFirebaseData() async {
    final events = await Firestore.fetchFutureEvents();
    await EventRepository.importFutureEvents(events);
  }

  Future<void> loadEvents() async {
    try {
      final events = EventRepository.getFutureEventsSortedByDate();
      emit(events);
    } catch (e) {
      logger.e('Failed to load future events: $e');
      emit([]);
    }
  }
}