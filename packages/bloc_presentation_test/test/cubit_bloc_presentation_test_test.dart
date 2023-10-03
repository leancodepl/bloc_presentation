import 'dart:async';

import 'package:bloc_presentation_test/src/bloc_presentation_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'cubits/cubits.dart';

class _MockRepository extends Mock implements Repository {}

void main() {
  group('blocPresentationTest', () {
    group('CounterCubit', () {
      blocPresentationTest<CounterCubit, int, CounterPresentationEvent>(
        'emits [] when nothing is called',
        build: CounterCubit.new,
        expectPresentation: () => const <CounterPresentationEvent>[],
      );

      blocPresentationTest<CounterCubit, int, CounterPresentationEvent>(
        'emits [IncrementPresentationEvent(1)] when increment is called',
        build: CounterCubit.new,
        act: (cubit) => cubit.increment(),
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(1),
        ],
      );

      blocPresentationTest<CounterCubit, int, CounterPresentationEvent>(
        'emits [IncrementPresentationEvent(1)] when increment is called with '
        'async act',
        build: CounterCubit.new,
        act: (cubit) => cubit.increment(),
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(1),
        ],
      );

      blocPresentationTest<CounterCubit, int, CounterPresentationEvent>(
        'emits ['
        'IncrementPresentationEvent(1) '
        'IncrementPresentationEvent(2)'
        '] when increment is called multiple times with async act',
        build: CounterCubit.new,
        act: (cubit) => cubit
          ..increment()
          ..increment(),
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(1),
          IncrementPresentationEvent(2),
        ],
      );

      blocPresentationTest<CounterCubit, int, CounterPresentationEvent>(
        'emits [IncrementPresentationEvent(3)] when increment is called and '
        'seed is 2 with async act',
        build: CounterCubit.new,
        seed: () => 2,
        act: (cubit) => cubit.increment(),
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(3),
        ],
      );

      blocPresentationTest<CounterCubit, int, CounterPresentationEvent>(
        'emits [IncrementPresentationEvent(2)] when increment is called 2 '
        'times and skipPresentation is set to 1',
        build: CounterCubit.new,
        act: (cubit) => cubit
          ..increment()
          ..increment(),
        skipPresentation: 1,
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(2),
        ],
      );

      test('fails immediately when exception occurs in act', () async {
        final exception = Exception('oops');
        late Object actualError;

        final completer = Completer<void>();

        await runZonedGuarded(() async {
          unawaited(
            testBlocPresentation<CounterCubit, int, CounterPresentationEvent>(
              build: CounterCubit.new,
              act: (_) => throw exception,
              expectPresentation: () => const <CounterPresentationEvent>[
                IncrementPresentationEvent(1),
              ],
            ).then((_) => completer.complete()),
          );

          await completer.future;
        }, (error, _) {
          actualError = error;

          if (!completer.isCompleted) {
            completer.complete();
          }
        });

        expect(actualError, exception);
      });

      test('calls tearDown once after the test', () async {
        var tearDownCalls = 0;

        await testBlocPresentation<AsyncCounterCubit, int,
            CounterPresentationEvent>(
          build: AsyncCounterCubit.new,
          expectPresentation: () => const <CounterPresentationEvent>[],
          tearDown: () {
            tearDownCalls++;
          },
        );

        expect(tearDownCalls, 1);
      });

      test(
        'fails immediately when expectation is list which has the same length '
        'as actual list lists do not match ',
        () async {
          const expectedError =
              'Expected: [IncrementPresentationEvent:IncrementPresentationEvent(2)]\n'
              '  Actual: [IncrementPresentationEvent:IncrementPresentationEvent(1)]\n'
              '   Which: at location [0] is IncrementPresentationEvent:<IncrementPresentationEvent(1)> instead of IncrementPresentationEvent:<IncrementPresentationEvent(2)>\n'
              '\n'
              '==== diff ========================================\n'
              '\n'
              '\x1B[90m[IncrementPresentationEvent(\x1B[0m\x1B[31m[-2-]\x1B[0m\x1B[32m{+1+}\x1B[0m\x1B[90m)]\x1B[0m\n'
              '\n'
              '==== end diff ====================================\n';
          late Object actualError;
          final completer = Completer<void>();

          await runZonedGuarded(() async {
            unawaited(
              testBlocPresentation<CounterCubit, int, CounterPresentationEvent>(
                build: CounterCubit.new,
                act: (cubit) => cubit.increment(),
                expectPresentation: () => const <CounterPresentationEvent>[
                  IncrementPresentationEvent(2),
                ],
              ).then((_) => completer.complete()),
            );

            await completer.future;
          }, (error, _) {
            actualError = error;

            if (!completer.isCompleted) {
              completer.complete();
            }
          });

          expect((actualError as TestFailure).message, expectedError);
        },
      );

      test(
        'fails immediately when expectation is list which is shorter than '
        'actual list',
        () async {
          const expectedError = 'Expected: []\n'
              '  Actual: [IncrementPresentationEvent:IncrementPresentationEvent(1)]\n'
              '   Which: at location [0] is [IncrementPresentationEvent:IncrementPresentationEvent(1)] which longer than expected\n'
              '\n'
              '==== diff ========================================\n'
              '\n'
              '\x1B[90m[\x1B[0m\x1B[32m{+IncrementPresentationEvent(1)+}\x1B[0m\x1B[90m]\x1B[0m\n'
              '\n'
              '==== end diff ====================================\n';
          late Object actualError;
          final completer = Completer<void>();

          await runZonedGuarded(() async {
            unawaited(
              testBlocPresentation<CounterCubit, int, CounterPresentationEvent>(
                build: CounterCubit.new,
                act: (cubit) => cubit.increment(),
                expectPresentation: () => const <CounterPresentationEvent>[],
              ).then((_) => completer.complete()),
            );

            await completer.future;
          }, (error, _) {
            actualError = error;

            if (!completer.isCompleted) {
              completer.complete();
            }
          });

          expect((actualError as TestFailure).message, expectedError);
        },
      );

      test(
        'fails immediately when expectation is list which is longer than '
        'actual list',
        () async {
          const expectedError = 'Expected: [\n'
              '            IncrementPresentationEvent:IncrementPresentationEvent(1),\n'
              '            IncrementPresentationEvent:IncrementPresentationEvent(2)\n'
              '          ]\n'
              '  Actual: [IncrementPresentationEvent:IncrementPresentationEvent(1)]\n'
              '   Which: at location [1] is [IncrementPresentationEvent:IncrementPresentationEvent(1)] which shorter than expected\n'
              '\n'
              '==== diff ========================================\n'
              '\n'
              '\x1B[90m[IncrementPresentationEvent(1)\x1B[0m\x1B[31m[-, IncrementPresentationEvent(2)-]\x1B[0m\x1B[90m]\x1B[0m\n'
              '\n'
              '==== end diff ====================================\n';
          late Object actualError;
          final completer = Completer<void>();

          await runZonedGuarded(() async {
            unawaited(
              testBlocPresentation<CounterCubit, int, CounterPresentationEvent>(
                build: CounterCubit.new,
                act: (cubit) => cubit.increment(),
                expectPresentation: () => const <CounterPresentationEvent>[
                  IncrementPresentationEvent(1),
                  IncrementPresentationEvent(2),
                ],
              ).then((_) => completer.complete()),
            );

            await completer.future;
          }, (error, _) {
            actualError = error;

            if (!completer.isCompleted) {
              completer.complete();
            }
          });

          expect((actualError as TestFailure).message, expectedError);
        },
      );
    });

    group('AsyncCounterCubit', () {
      blocPresentationTest<AsyncCounterCubit, int, CounterPresentationEvent>(
        'emits [] when nothing is called',
        build: AsyncCounterCubit.new,
        expectPresentation: () => const <CounterPresentationEvent>[],
      );

      blocPresentationTest<AsyncCounterCubit, int, CounterPresentationEvent>(
        'emits [IncrementPresentationEvent(1)] when increment is called',
        build: AsyncCounterCubit.new,
        act: (cubit) => cubit.increment(),
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(1),
        ],
      );

      blocPresentationTest<AsyncCounterCubit, int, CounterPresentationEvent>(
        'emits ['
        'IncrementPresentationEvent(1) '
        'IncrementPresentationEvent(2)'
        '] when increment is called multiple times with async act',
        build: AsyncCounterCubit.new,
        act: (cubit) async {
          await cubit.increment();
          await cubit.increment();
        },
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(1),
          IncrementPresentationEvent(2),
        ],
      );
    });

    group('DelayedCounterCubit', () {
      blocPresentationTest<DelayedCounterCubit, int, CounterPresentationEvent>(
        'emits [] when nothing is called',
        build: DelayedCounterCubit.new,
        expectPresentation: () => <CounterPresentationEvent>[],
      );

      blocPresentationTest<DelayedCounterCubit, int, CounterPresentationEvent>(
        'emits [] when increment is called without wait',
        build: DelayedCounterCubit.new,
        act: (cubit) => cubit.increment(),
        expectPresentation: () => const <CounterPresentationEvent>[],
      );

      blocPresentationTest<DelayedCounterCubit, int, CounterPresentationEvent>(
        'emits [IncrementPresentationEvent(1)] when increment is called with '
        'wait',
        build: DelayedCounterCubit.new,
        act: (cubit) => cubit.increment(),
        wait: const Duration(milliseconds: 300),
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(1),
        ],
      );
    });

    group('InstantEmitCubit', () {
      blocPresentationTest<InstantEmitCubit, int, CounterPresentationEvent>(
        'emits [] when nothing is called',
        build: InstantEmitCubit.new,
        expectPresentation: () => const <CounterPresentationEvent>[],
      );

      blocPresentationTest<InstantEmitCubit, int, CounterPresentationEvent>(
        'emits [IncrementPresentationEvent(1)] when increment is called',
        build: InstantEmitCubit.new,
        act: (cubit) => cubit.increment(),
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(1),
        ],
      );

      blocPresentationTest<InstantEmitCubit, int, CounterPresentationEvent>(
        'emits ['
        'IncrementPresentationEvent(1) '
        'IncrementPresentationEvent(2)'
        '] when increment is called multiple times with async act',
        build: InstantEmitCubit.new,
        act: (cubit) async {
          cubit.increment();

          await Future<void>.delayed(const Duration(microseconds: 1));

          cubit.increment();
        },
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(1),
          IncrementPresentationEvent(2),
        ],
      );
    });

    group('MultiCounterCubit', () {
      blocPresentationTest<MultiCounterCubit, int, CounterPresentationEvent>(
        'emits [] when nothing is called',
        build: MultiCounterCubit.new,
        expectPresentation: () => <CounterPresentationEvent>[],
      );

      blocPresentationTest<MultiCounterCubit, int, CounterPresentationEvent>(
        'emits ['
        'IncrementPresentationEvent(1) '
        'IncrementPresentationEvent(2)'
        '] when increment is called',
        build: MultiCounterCubit.new,
        act: (cubit) => cubit.increment(),
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(1),
          IncrementPresentationEvent(2),
        ],
      );

      blocPresentationTest<MultiCounterCubit, int, CounterPresentationEvent>(
        'emits ['
        'IncrementPresentationEvent(1) '
        'IncrementPresentationEvent(2) '
        'IncrementPresentationEvent(3) '
        'IncrementPresentationEvent(4)'
        '] when increment is called '
        'multiple times with async act',
        build: MultiCounterCubit.new,
        act: (cubit) => cubit
          ..increment()
          ..increment(),
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(1),
          IncrementPresentationEvent(2),
          IncrementPresentationEvent(3),
          IncrementPresentationEvent(4),
        ],
      );
    });

    group('SideEffectCounterCubit', () {
      late _MockRepository repository;

      setUp(() {
        repository = _MockRepository();
      });

      blocPresentationTest<SideEffectCounterCubit, int,
          CounterPresentationEvent>(
        'emits [] when increment is called and repository.increment returned '
        'false',
        setUp: () {
          when(repository.increment).thenReturn(false);
        },
        build: () => SideEffectCounterCubit(repository),
        act: (cubit) => cubit.increment(),
        expectPresentation: () => const <CounterPresentationEvent>[],
      );

      blocPresentationTest<SideEffectCounterCubit, int,
          CounterPresentationEvent>(
        'emits [IncrementPresentationEvent(1)] when increment is called and '
        'repository.increment returned false',
        setUp: () {
          when(repository.increment).thenReturn(true);
        },
        build: () => SideEffectCounterCubit(repository),
        act: (cubit) => cubit.increment(),
        expectPresentation: () => const <CounterPresentationEvent>[
          IncrementPresentationEvent(1),
        ],
      );
    });

    group(
      'ExceptionCounterCubit',
      () {
        test('future still completes when uncaught exception occurs', () async {
          await expectLater(
            () => testBlocPresentation<ExceptionCounterCubit, int,
                CounterPresentationEvent>(
              build: ExceptionCounterCubit.new,
              act: (cubit) => cubit.increment(),
              expectPresentation: () => const <CounterPresentationEvent>[
                IncrementPresentationEvent(1),
              ],
            ),
            throwsA(isA<CounterException>()),
          );
        });
      },
    );

    group(
      'ErrorCounterCubit',
      () {
        test('future still completes when uncaught error occurs', () async {
          await expectLater(
            () => testBlocPresentation<ErrorCounterCubit, int,
                CounterPresentationEvent>(
              build: ErrorCounterCubit.new,
              act: (cubit) => cubit.increment(),
              expectPresentation: () => const <CounterPresentationEvent>[
                IncrementPresentationEvent(1),
              ],
            ),
            throwsA(isA<CounterError>()),
          );
        });
      },
    );

    group('NonEquatableCounterCubit', () {
      test('adds additional warning to thrown exception message', () async {
        const warning = '\n'
            'WARNING: Please ensure presentation events instances extend Equatable, override == and hashCode, or implement Comparable.\n'
            'Alternatively, consider using Matchers in the expectPresentation of the blocPresentationTest rather than concrete presentation events instances.\n';
        late Object actualError;
        final completer = Completer<void>();

        await runZonedGuarded(() async {
          unawaited(
            testBlocPresentation<NonEquatableCounterCubit, int,
                NonEquatableCounterPresentationEvent>(
              build: NonEquatableCounterCubit.new,
              act: (cubit) => cubit.increment(),
              expectPresentation: () =>
                  const <NonEquatableCounterPresentationEvent>[
                NonEquatableIncrementPresentationEvent(1),
              ],
            ).then((_) => completer.complete()),
          );

          await completer.future;
        }, (error, _) {
          actualError = error;

          if (!completer.isCompleted) {
            completer.complete();
          }
        });

        expect((actualError as TestFailure).message?.contains(warning), true);
      });
    });
  });
}
