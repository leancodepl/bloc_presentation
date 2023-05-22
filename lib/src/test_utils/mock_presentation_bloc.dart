import 'dart:async';

import 'package:bloc_presentation/src/bloc_presentation_event.dart';
import 'package:bloc_presentation/src/bloc_presentation_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

/// A mock for [BlocPresentationMixin]ed blocs. Allows managing presentation
/// stream.
class MockPresentationBloc<E, S> extends _MockBlocPresentationBase<S>
    implements Bloc<E, S> {}

/// A mock for [BlocPresentationMixin]ed cubits. Allows managing presentation
/// stream.
class MockPresentationCubit<S> extends _MockBlocPresentationBase<S>
    implements Cubit<S> {}

class _MockBlocPresentationBase<S> extends Mock
    implements BlocPresentationMixin<S> {
  _MockBlocPresentationBase() {
    when(() => stream).thenAnswer((_) => Stream<S>.empty());
    when(() => presentation).thenAnswer((_) => _presentationController.stream);
    when(close).thenAnswer((_) => _presentationController.close());
  }

  final _presentationController = StreamController<BlocPresentationEvent>();

  void emitMockPresentationEvent(BlocPresentationEvent event) {
    _presentationController.add(event);
  }
}
