import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/subjects.dart';

/// A mock for [BlocPresentationMixin]ed blocs. Allows managing presentation
/// stream.
class MockPresentationBloc2<E, S> extends _MockBlocPresentationBase2<S>
    implements Bloc<E, S> {}

/// A mock for [BlocPresentationMixin]ed cubits. Allows managing presentation
/// stream.
class MockPresentationCubit2<S> extends _MockBlocPresentationBase2<S>
    implements Cubit<S> {}

class _MockBlocPresentationBase2<S> extends Mock
    implements BlocPresentationMixin<S> {
  _MockBlocPresentationBase2([S? seed]) {
    _subject = seed != null ? BehaviorSubject.seeded(seed) : BehaviorSubject();
    _presentationController = StreamController();

    when(() => state).thenAnswer((_) => _subject.value);
    when(() => stream).thenAnswer((_) => _subject.stream.skip(1));
    when(() => presentation).thenAnswer((_) => _presentationController.stream);
    when(close).thenAnswer(
      (_) => Future.wait<void>([
        _subject.close(),
        _presentationController.close(),
      ]),
    );
  }

  late final BehaviorSubject<S> _subject;
  late final StreamController<BlocPresentationEvent> _presentationController;

  @override
  void emit(S state) => _subject.add(state);

  void emitMockPresentationEvent(BlocPresentationEvent event) =>
      _presentationController.add(event);
}
