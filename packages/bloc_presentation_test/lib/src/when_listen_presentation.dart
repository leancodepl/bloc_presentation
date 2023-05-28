import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:mocktail/mocktail.dart';

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
