import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

class CounterCubit extends Cubit<int>
    with BlocPresentationMixin<int, CounterCubitEvent> {
  CounterCubit() : super(0);

  void count() {
    final newNumber = state + 1;

    if (state < 10) {
      emitPresentation(CounterPresentationEvent(newNumber));
    }

    emit(newNumber);
  }
}

sealed class CounterCubitEvent {}

final class CounterPresentationEvent implements CounterCubitEvent {
  const CounterPresentationEvent(this.number);

  final int number;

  @override
  int get hashCode => number;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is CounterPresentationEvent && other.number == number;
  }
}

class MockCounterPresentationCubit
    extends MockPresentationCubit<int, CounterCubitEvent>
    implements CounterCubit {}

class MockCounterCubit extends MockCubit<int> implements CounterCubit {}

void main() {
  mainMockPresentationCubit();
  mainWhenListenPresentation();
  mainBlocPresentationTest();
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
      mockCubit.emitMockPresentation(const CounterPresentationEvent(5));

      await expectLater(
        mockCubit.presentation,
        emitsInOrder(
          <Matcher>[
            equals(const CounterPresentationEvent(5)),
          ],
        ),
      );
    },
  );
}

void mainWhenListenPresentation() {
  late MockCounterCubit mockCubit;
  late StreamController<CounterCubitEvent> controller;

  setUp(() {
    mockCubit = MockCounterCubit();
    controller = whenListenPresentation(
      mockCubit,
      initialEvents: [const CounterPresentationEvent(1)],
    );
  });

  tearDown(() {
    mockCubit.close();
  });

  test(
    'presentation stream emits events properly',
    () async {
      controller.add(const CounterPresentationEvent(2));

      await expectLater(
        mockCubit.presentation,
        emitsInOrder(
          <Matcher>[
            equals(const CounterPresentationEvent(1)),
            equals(const CounterPresentationEvent(2)),
          ],
        ),
      );
    },
  );
}

void mainBlocPresentationTest() {
  CounterCubit buildCubit() => CounterCubit();

  blocPresentationTest<CounterCubit, int, CounterCubitEvent>(
    'emits correct presentation event after calling count when state was '
    'smaller than 10',
    build: buildCubit,
    act: (cubit) => cubit.count(),
    expectPresentation: () => const [
      CounterPresentationEvent(1),
    ],
  );

  blocPresentationTest<CounterCubit, int, CounterCubitEvent>(
    'does not emit presentation event if count has not ben called',
    build: buildCubit,
    expectPresentation: () => const <CounterPresentationEvent>[],
  );

  blocPresentationTest<CounterCubit, int, CounterCubitEvent>(
    'emits correct presentation event after calling count 2 times when state '
    'was smaller than 10',
    build: buildCubit,
    act: (cubit) => cubit
      ..count()
      ..count(),
    // skipPresentation can be used for skipping events during verification
    skipPresentation: 1,
    expectPresentation: () => const [
      CounterPresentationEvent(2),
    ],
  );

  blocPresentationTest<CounterCubit, int, CounterCubitEvent>(
    'does not emit presentation event after calling count when state was 10',
    build: buildCubit,
    seed: () => 10,
    act: (cubit) => cubit.count(),
    expectPresentation: () => const <CounterPresentationEvent>[],
  );
}
