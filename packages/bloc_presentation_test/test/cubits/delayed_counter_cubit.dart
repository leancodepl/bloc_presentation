import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';

import 'events.dart';

class DelayedCounterCubit extends Cubit<int>
    with BlocPresentationMixin<int, CounterPresentationEvent> {
  DelayedCounterCubit() : super(0);

  void increment() {
    Future<void>.delayed(
      const Duration(milliseconds: 300),
      () {
        if (!isClosed) {
          final newNumber = state + 1;

          emitPresentation(IncrementPresentationEvent(newNumber));

          emit(newNumber);
        }
      },
    );
  }
}
