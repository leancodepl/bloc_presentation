import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

class _FakeBuildContext extends Fake implements BuildContext {}

class _FakeBlocPresentationEvent extends Fake implements BlocPresentationEvent {
}

void registerFakes() {
  registerFallbackValue(_FakeBuildContext());
  registerFallbackValue(_FakeBlocPresentationEvent());
}
