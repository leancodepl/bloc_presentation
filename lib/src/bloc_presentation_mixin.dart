import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/src/bloc_presentation_event.dart';
import 'package:flutter/foundation.dart';

mixin BlocPresentationMixin<S> on BlocBase<S> {
  final _presentationStream =
      StreamController<BlocPresentationEvent>.broadcast();

  Stream<BlocPresentationEvent> get presentation => _presentationStream.stream;

  @protected
  void emitPresentation(BlocPresentationEvent event) =>
      _presentationStream.add(event);

  @override
  Future<void> close() async {
    await _presentationStream.close();
    await super.close();
  }
}
