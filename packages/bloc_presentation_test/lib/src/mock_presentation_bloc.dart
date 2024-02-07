import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:mocktail/mocktail.dart';

/// A mock for [BlocPresentationMixin]ed blocs. Allows managing presentation
/// stream. It automatically mocks all fields and methods.
/// It allows to add presentation events to bloc's [presentation] stream.
class MockPresentationBloc<E, S, P> extends _MockPresentationBlocBase<S, P>
    implements Bloc<E, S> {}

/// A mock for [BlocPresentationMixin]ed cubits. Allows managing presentation
/// stream. It automatically mocks all fields and methods.
/// It allows to add presentation events to cubit's [presentation] stream.
class MockPresentationCubit<S, P> extends _MockPresentationBlocBase<S, P>
    implements Cubit<S> {}

class _MockPresentationBlocBase<S, P> extends Mock
    implements BlocPresentationMixin<S, P> {
  _MockPresentationBlocBase() {
    when(() => stream).thenAnswer((_) => Stream<S>.empty());
    when(() => presentation).thenAnswer((_) => _presentationController.stream);
    when(close).thenAnswer((_) => _presentationController.close());
  }

  final _presentationController = StreamController<P>.broadcast();

  /// Adds given [event] to bloc's presentation stream.
  void emitMockPresentation(P event) {
    _presentationController.add(event);
  }
}
