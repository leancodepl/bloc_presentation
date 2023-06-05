import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

class CounterCubit extends Cubit<int> with BlocPresentationMixin {
  CounterCubit() : super(0);
}

class CounterPresentationEvent extends BlocPresentationEvent {
  const CounterPresentationEvent();
}

class MockCounterPresentationCubit extends MockPresentationCubit<int>
    implements CounterCubit {}

class MockCounterCubit extends MockCubit<int> implements CounterCubit {}

void main() {
  mainMockPresentationCubit();
  mainWhenListenPresentation();
}

void mainMockPresentationCubit() {
  late MockCounterPresentationCubit mockCubit;

  setUp(() {
    mockCubit = MockCounterPresentationCubit();
  });

  tearDown(() {
    mockCubit.close();
  });

  test(
    'presentation stream emits events properly',
    () async {
      mockCubit.emitMockPresentation(const CounterPresentationEvent());

      await expectLater(
        mockCubit.presentation,
        emitsInOrder(
          <Matcher>[
            equals(const CounterPresentationEvent()),
          ],
        ),
      );
    },
  );
}

void mainWhenListenPresentation() {
  late MockCounterCubit mockCubit;
  late StreamController<CounterPresentationEvent> controller;

  setUp(() {
    mockCubit = MockCounterCubit();
    controller = whenListenPresentation(
      mockCubit,
      initialEvents: [const CounterPresentationEvent()],
    );
  });

  tearDown(() {
    mockCubit.close();
  });

  test(
    'presentation stream emits events properly',
    () async {
      controller.add(const CounterPresentationEvent());

      await expectLater(
        mockCubit.presentation,
        emitsInOrder(
          <Matcher>[
            equals(const CounterPresentationEvent()),
            equals(const CounterPresentationEvent()),
          ],
        ),
      );
    },
  );
}
