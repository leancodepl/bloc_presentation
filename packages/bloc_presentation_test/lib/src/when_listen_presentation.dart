import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:mocktail/mocktail.dart';

/// Creates a StreamController, stubs bloc's presentation stream with created
/// controller's stream and returns newly created controller. Newly created
/// controller is automatically closed when bloc's close method is called.
///
/// [initialEvents] can be provided for stubbing bloc's presentation stream
/// before subscribing to bloc's presentation stream.
StreamController<T> whenListenPresentation<T>(
  BlocPresentationMixin<dynamic, T> bloc, {
  List<T>? initialEvents,
}) {
  final presentationController = StreamController<T>.broadcast();

  initialEvents?.forEach(presentationController.add);

  when(() => bloc.presentation)
      .thenAnswer((_) => presentationController.stream);

  when(bloc.close).thenAnswer((_) => presentationController.close());

  return presentationController;
}
