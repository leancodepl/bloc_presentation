import 'dart:async';

import 'package:bloc_presentation/src/bloc_presentation_event.dart';
import 'package:bloc_presentation/src/bloc_presentation_mixin.dart';
import 'package:mocktail/mocktail.dart';

/// [bloc] - targeted bloc (implementing BlocPresentationMixin)
/// [events] - events to be emitted from [bloc]'s presentation stream
StreamController<BlocPresentationEvent> whenListenPresentation(
  BlocPresentationMixin bloc, {
  List<BlocPresentationEvent>? initialEvents,
}) {
  final presentationController = StreamController<BlocPresentationEvent>()
    ..addStream(Stream.fromIterable(initialEvents ?? []));

  when(() => bloc.presentation)
      .thenAnswer((_) => presentationController.stream);

  return presentationController;
}
