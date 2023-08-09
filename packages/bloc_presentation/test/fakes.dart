import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

class _FakeBuildContext extends Fake implements BuildContext {}

void registerFakes() {
  registerFallbackValue(_FakeBuildContext());
}
