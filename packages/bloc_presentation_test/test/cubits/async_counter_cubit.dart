import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';

import 'events.dart';

class AsyncCounterCubit extends Cubit<int>
    with BlocPresentationMixin<int, CounterPresentationEvent> {
  AsyncCounterCubit() : super(0);

  Future<void> increment() async {
    final newNumber = state + 1;

    await Future<void>.delayed(const Duration(microseconds: 1));

    emitPresentation(IncrementPresentationEvent(newNumber));

    emit(newNumber);
  }
}
