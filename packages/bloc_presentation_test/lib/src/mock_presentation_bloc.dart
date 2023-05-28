import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockPresentationBloc<E, S> extends _MockPresentationBlocBase<S>
    implements Bloc<E, S> {}

class MockPresentationCubit<S> extends _MockPresentationBlocBase<S>
    implements Cubit<S> {}

class _MockPresentationBlocBase<S> extends Mock
    implements BlocPresentationMixin<S> {
  _MockPresentationBlocBase() {
    when(() => stream).thenAnswer((_) => Stream<S>.empty());
    when(() => presentation).thenAnswer((_) => _presentationController.stream);
    when(close).thenAnswer((_) => _presentationController.close());
  }

  final _presentationController = StreamController<BlocPresentationEvent>();

  void emitMockPresentation(BlocPresentationEvent event) {
    _presentationController.add(event);
  }
}
