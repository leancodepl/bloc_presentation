import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';

import 'events.dart';

class NonEquatableCounterCubit extends Cubit<int>
    with BlocPresentationMixin<int, NonEquatableCounterPresentationEvent> {
  NonEquatableCounterCubit() : super(0);

  void increment() {
    final newNumber = state + 1;

    emitPresentation(NonEquatableIncrementPresentationEvent(newNumber));

    emit(newNumber);
  }
}
