import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:mocktail/mocktail.dart';

/// A mock for [BlocPresentationMixin]ed blocs. Allows managing presentation
/// stream. It automatically mocks all fields and methods.
/// It allows to add [BlocPresentationEvent]s to bloc's [presentation] stream.
class MockPresentationBloc<E, S> extends _MockPresentationBlocBase<S>
    implements Bloc<E, S> {}

/// A mock for [BlocPresentationMixin]ed cubits. Allows managing presentation
/// stream. It automatically mocks all fields and methods.
/// It allows to add [BlocPresentationEvent]s to cubit's [presentation] stream.
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

  /// Adds given [event] to bloc's presentation stream.
  void emitMockPresentation(BlocPresentationEvent event) {
    _presentationController.add(event);
  }
}
