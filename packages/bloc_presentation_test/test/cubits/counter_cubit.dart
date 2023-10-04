import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';

import 'events.dart';

class CounterCubit extends Cubit<int>
    with BlocPresentationMixin<int, CounterPresentationEvent> {
  CounterCubit() : super(0);

  void increment() {
    final newNumber = state + 1;

    emitPresentation(IncrementPresentationEvent(newNumber));

    emit(newNumber);
  }
}
