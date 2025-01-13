import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [BlocPresentationMixin] adds a presentation stream to a [EmittableStateStreamableSource]
/// which is automatically disposed.
mixin BlocPresentationMixin<S, P> on EmittableStateStreamableSource<S> {
  final _presentationStream = StreamController<P>.broadcast();

  /// Stream emitting non-unique presentation events.
  Stream<P> get presentation => _presentationStream.stream;

  /// Emits a new presentation event.
  @protected
  void emitPresentation(P event) => _presentationStream.add(event);

  @override
  @mustCallSuper
  Future<void> close() async {
    await _presentationStream.close();
    await super.close();
  }
}
