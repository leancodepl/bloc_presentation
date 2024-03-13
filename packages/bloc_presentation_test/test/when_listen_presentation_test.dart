import 'dart:async';

import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'cubits/counter_cubit.dart';

class _MockCounterCubit extends Mock implements CounterCubit {}

void main() {
  late _MockCounterCubit cubit;
  late List<StreamSubscription<dynamic>> subscriptions;

  setUp(() {
    cubit = _MockCounterCubit();

    subscriptions = [];
  });

  tearDown(() async {
    await cubit.close();
    await subscriptions.map((sub) => sub.cancel()).wait;
  });

  group('whenListenPresentation', () {
    test(
      'returns controller whose stream can be listened to more than once',
      () {
        final controller = whenListenPresentation(cubit);

        subscriptions.add(controller.stream.listen((_) {}));

        expect(
          () => subscriptions.add(controller.stream.listen((_) {})),
          returnsNormally,
        );
      },
    );

    test(
      'stubs cubit presentation with a stream that can be listened to more '
      'than once',
      () {
        whenListenPresentation(cubit);

        subscriptions.add(cubit.presentation.listen((_) {}));

        expect(
          () => subscriptions.add(cubit.presentation.listen((_) {})),
          returnsNormally,
        );
      },
    );
  });
}
