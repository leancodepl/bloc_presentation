import 'dart:async';

import 'package:bloc_presentation/src/bloc_presentation_event.dart';
import 'package:bloc_presentation/src/bloc_presentation_mixin.dart';
import 'package:mocktail/mocktail.dart';

/// [bloc] - targeted bloc (implementing BlocPresentationMixin)
/// [initialEvents] - events to be emitted from [bloc]'s presentation stream
/// initially
///
/// Returns StreamController for managing presentation events.
StreamController<BlocPresentationEvent> whenListenPresentation(
  BlocPresentationMixin bloc, {
  List<BlocPresentationEvent>? initialEvents,
}) {
  final presentationController = StreamController<BlocPresentationEvent>()
    ..addStream(Stream.fromIterable(initialEvents ?? []));

  when(() => bloc.presentation)
      .thenAnswer((_) => presentationController.stream);

  when(bloc.close).thenAnswer((_) => presentationController.close());

  return presentationController;
}
