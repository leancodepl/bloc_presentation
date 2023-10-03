import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';

import 'events.dart';

class Repository {
  bool increment() => true;
}

class SideEffectCounterCubit extends Cubit<int>
    with BlocPresentationMixin<int, CounterPresentationEvent> {
  SideEffectCounterCubit(this.repository) : super(0);

  final Repository repository;

  void increment() {
    final incremented = repository.increment();

    if (incremented) {
      final newNumber = state + 1;

      emitPresentation(IncrementPresentationEvent(newNumber));

      emit(newNumber);
    }
  }
}
