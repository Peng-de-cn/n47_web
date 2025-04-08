
import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/event.dart';
import '../database/event_repository.dart';
import '../utils/logger_util.dart';

class EventsCubit extends Cubit<List<Event>> {

  EventsCubit() : super([]) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      final events = EventRepository.getHistoryEventsSortedByDate();
      emit(events);
    } catch (e) {
      logger.e('Failed to load events: $e');
      emit([]);
    }
  }
}