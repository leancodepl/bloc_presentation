import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';

import 'events.dart';

class InstantEmitCubit extends Cubit<int>
    with BlocPresentationMixin<int, CounterPresentationEvent> {
  InstantEmitCubit() : super(0) {
    emitPresentation(const InitialPresentationEvent(0));
  }

  void increment() {
    final newNumber = state + 1;

    emitPresentation(IncrementPresentationEvent(newNumber));

    emit(newNumber);
  }
}
