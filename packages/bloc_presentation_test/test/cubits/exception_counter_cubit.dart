import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';

import 'events.dart';

class CounterException implements Exception {}

class ExceptionCounterCubit extends Cubit<int>
    with BlocPresentationMixin<int, CounterPresentationEvent> {
  ExceptionCounterCubit() : super(0);

  void increment() {
    throw CounterException();
  }
}
