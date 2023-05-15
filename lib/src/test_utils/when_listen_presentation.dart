import 'dart:async';

import 'package:bloc_presentation/src/bloc_presentation_event.dart';
import 'package:bloc_presentation/src/bloc_presentation_mixin.dart';
import 'package:mocktail/mocktail.dart';

/// Approach 1.
///
/// [bloc] - targeted bloc (implementing BlocPresentationMixin)
/// [stream] - stub stream response from [bloc]'s presentation stream
void whenListenPresentation1(
  BlocPresentationMixin bloc,
  Stream<BlocPresentationEvent> stream,
) {
  final broadcastStream = stream.asBroadcastStream();

  when(() => bloc.presentation).thenAnswer((_) => broadcastStream);
}

/// Approach 2.
///
/// [bloc] - targeted bloc (implementing BlocPresentationMixin)
/// [events] - events to be emitted from stubbed [bloc]'s presentation stream
/// response
void whenListenPresentation2(
  BlocPresentationMixin bloc,
  List<BlocPresentationEvent> events,
) {
  when(() => bloc.presentation).thenAnswer((_) => Stream.fromIterable(events));
}

/// Approach 3.
///
/// [bloc] - targeted bloc (implementing BlocPresentationMixin)
/// [controller] - stream controller for managing events
void whenListenPresentation3(
  BlocPresentationMixin bloc,
  StreamController<BlocPresentationEvent> controller,
) {
  when(() => bloc.presentation).thenAnswer((_) => controller.stream);

  when(bloc.close).thenAnswer((_) async => controller.close());
}

/// Approach 4.
///
/// A mock class for [BlocPresentationMixin]-based blocs / cubits
///
/// It behaves similarly to MockBloc / MockCubit from bloc_test package but
/// allows to add mock presentation events.
class MockPresentationBloc<S> extends Mock implements BlocPresentationMixin<S> {
  /// Constructor responsible for setting up stubs
  MockPresentationBloc() {
    when(() => stream).thenAnswer((_) => Stream<S>.empty());
    when(() => presentation).thenAnswer((_) => _streamController.stream);
    when(close).thenAnswer((_) async => _streamController.close());
  }

  final _streamController = StreamController<BlocPresentationEvent>.broadcast();

  /// Sends given event to bloc's presentation stream
  void addMockPresentationEvent(BlocPresentationEvent event) {
    _streamController.add(event);
  }
}
