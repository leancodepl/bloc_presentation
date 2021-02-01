import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

mixin BlocPresentation<E, S> on Cubit<S> {
  final _presentationStream = StreamController<E>.broadcast();

  Stream<E> get presentation => _presentationStream.stream;

  @protected
  void emitPresentation(E event) => _presentationStream.add(event);

  Future<void> close() async {
    await _presentationStream.close();
    await super.close();
  }
}
