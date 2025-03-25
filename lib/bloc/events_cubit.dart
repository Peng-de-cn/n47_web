import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/event.dart';

class EventsCubit extends Cubit<List<Event>> {
  EventsCubit() : super([]);

  void loadEvents(List<Event> events) => emit(events);
}