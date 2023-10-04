import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';

import 'events.dart';

class MultiCounterCubit extends Cubit<int>
    with BlocPresentationMixin<int, CounterPresentationEvent> {
  MultiCounterCubit() : super(0);

  void increment() {
    var newNumber = state + 1;

    emitPresentation(IncrementPresentationEvent(newNumber));

    newNumber = ++newNumber;

    emitPresentation(IncrementPresentationEvent(newNumber));

    emit(newNumber);
  }
}
