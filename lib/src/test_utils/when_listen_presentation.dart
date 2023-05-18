import 'dart:async';

import 'package:bloc_presentation/src/bloc_presentation_event.dart';
import 'package:bloc_presentation/src/bloc_presentation_mixin.dart';
import 'package:mocktail/mocktail.dart';

/// Approach 1.
///
/// [bloc] - targeted bloc (implementing BlocPresentationMixin)
/// [events] - events to be emitted from [bloc]'s presentation stream
/// [controller] - stream controller for managing bloc presentation events
void whenListenPresentation(
  BlocPresentationMixin bloc, {
  List<BlocPresentationEvent>? events,
  StreamController<BlocPresentationEvent>? controller,
}) {
  final effectiveStream =
      Stream<BlocPresentationEvent>.fromIterable(events ?? []);

  if (controller != null) {
    controller.addStream(effectiveStream);
  }

  when(() => bloc.presentation)
      .thenAnswer((_) => controller?.stream ?? effectiveStream);
}
