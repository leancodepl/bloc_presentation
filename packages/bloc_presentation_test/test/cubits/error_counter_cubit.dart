import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';

import 'events.dart';

class CounterError extends Error {}

class ErrorCounterCubit extends Cubit<int>
    with BlocPresentationMixin<int, CounterPresentationEvent> {
  ErrorCounterCubit() : super(0);

  void increment() {
    throw CounterError();
  }
}
