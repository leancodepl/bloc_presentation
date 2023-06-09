import 'dart:async';

import 'package:bloc_presentation/src/bloc_presentation_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [BlocPresentationMixin] adds a presentation stream to a [BlocBase]
/// which is automatically disposed.
mixin BlocPresentationMixin<S> on BlocBase<S> {
  final _presentationStream =
      StreamController<BlocPresentationEvent>.broadcast();

  /// Stream emitting non-unique presentation events.
  Stream<BlocPresentationEvent> get presentation => _presentationStream.stream;

  /// Emits a new presentation event.
  @protected
  void emitPresentation(BlocPresentationEvent event) =>
      _presentationStream.add(event);

  @override
  @mustCallSuper
  Future<void> close() async {
    await _presentationStream.close();
    await super.close();
  }
}
