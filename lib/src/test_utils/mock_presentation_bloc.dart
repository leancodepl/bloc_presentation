import 'dart:async';

import 'package:bloc_presentation/src/bloc_presentation_event.dart';
import 'package:bloc_presentation/src/bloc_presentation_mixin.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

/// Approach 2.
///
/// A mock for [BlocPresentationMixin]ed cubits. Allows managing presentation
/// stream.
class MockPresentationCubit<S> extends MockCubit<S>
    implements BlocPresentationMixin<S> {
  /// Stubs presentation stream.
  MockPresentationCubit() {
    when(() => presentation).thenAnswer((_) => _presentationController.stream);
    when(close).thenAnswer((_) => _presentationController.close());
  }

  final _presentationController = StreamController<BlocPresentationEvent>();

  /// Adds [event] to presentation stream
  void emitMockPresentationEvent(BlocPresentationEvent event) {
    _presentationController.add(event);
  }
}

/// A mock for [BlocPresentationMixin]ed blocs. Allows managing presentation
/// stream.
class MockPresentationBloc2<E, S> extends MockBloc<E, S>
    implements BlocPresentationMixin<S> {
  /// Stubs presentation stream.
  MockPresentationBloc2() {
    when(() => presentation).thenAnswer((_) => _presentationController.stream);
    when(close).thenAnswer((_) => _presentationController.close());
  }

  final _presentationController = StreamController<BlocPresentationEvent>();

  /// Adds [event] to presentation stream
  void emitMockPresentationEvent(BlocPresentationEvent event) {
    _presentationController.add(event);
  }
}

/// Another variant of 2. approach.
///
/// This variant allows us to get rid of bloc_test dependency and unnecessary
/// duplication of presentation mocking.

/// A mock for [BlocPresentationMixin]ed blocs. Allows managing presentation
/// stream.
class MockPresentationBlocX<E, S> extends _MockBlocPresentationBase<S>
    implements Bloc<E, S> {}

/// A mock for [BlocPresentationMixin]ed cubits. Allows managing presentation
/// stream.
class MockPresentationCubitX<S> extends _MockBlocPresentationBase<S>
    implements Cubit<S> {}

class _MockBlocPresentationBase<S> extends Mock
    implements BlocPresentationMixin<S> {
  _MockBlocPresentationBase() {
    // stream mocking - as in _MockBlocBase from bloc_test package
    when(() => stream).thenAnswer((_) => Stream<S>.empty());
    when(() => presentation).thenAnswer((_) => _presentationController.stream);
    when(close).thenAnswer((_) => _presentationController.close());
  }

  final _presentationController = StreamController<BlocPresentationEvent>();

  void emitMockPresentationEvent(BlocPresentationEvent event) {
    _presentationController.add(event);
  }
}
