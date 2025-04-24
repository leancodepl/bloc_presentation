import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

/// This function provides a possibility to test blocs/cubits with
/// [BlocPresentationMixin] mixed in.
///
/// Events emitted via presentation stream can be verified by
/// [expectPresentation].
///
/// This function is not intended to verify states, but
/// only to verify presentation events.
@isTest
void blocPresentationTest<B extends BlocPresentationMixin<State, P>, State, P>(
  String description, {
  required B Function() build,
  FutureOr<void> Function()? setUp,
  State Function()? seed,
  dynamic Function(B bloc)? act,
  Duration? wait,
  int skipPresentation = 0,
  required dynamic Function() expectPresentation,
  FutureOr<void> Function(B bloc)? verify,
  FutureOr<void> Function()? tearDown,
  dynamic tags,
}) {
  test(description, () async {
    await testBlocPresentation<B, State, P>(
      setUp: setUp,
      build: build,
      seed: seed,
      act: act,
      wait: wait,
      skipPresentation: skipPresentation,
      expectPresentation: expectPresentation,
      verify: verify,
      tearDown: tearDown,
    );
  }, tags: tags);
}

/// Internal [blocPresentationTest] runner which is only visible for testing.
/// This should never be used directly -- please use [blocPresentationTest]
/// instead.
@visibleForTesting
Future<void> testBlocPresentation<B extends BlocPresentationMixin<State, P>, State, P>({
  FutureOr<void> Function()? setUp,
  required B Function() build,
  State Function()? seed,
  dynamic Function(B bloc)? act,
  Duration? wait,
  int skipPresentation = 0,
  required dynamic Function() expectPresentation,
  FutureOr<void> Function(B bloc)? verify,
  FutureOr<void> Function()? tearDown,
  dynamic tags,
}) async {
  var shallowEquality = false;

  try {
    await _runZonedGuarded(() async {
      await setUp?.call();

      final events = <P>[];
      final bloc = build();

      if (seed != null) {
        bloc.emit(seed());
      }

      final subscription = bloc.presentation.skip(skipPresentation).listen(events.add);

      await act?.call(bloc);

      if (wait != null) {
        await Future<void>.delayed(wait);
      }

      await Future<void>.delayed(Duration.zero);
      await bloc.close();

      final dynamic expected = expectPresentation();
      shallowEquality = '$events' == '$expected';

      try {
        expect(events, wrapMatcher(expected));
      } on TestFailure catch (e) {
        if (shallowEquality || expected is! List<P>) {
          rethrow;
        }

        final diff = _diff(expected: expected, actual: events);
        final message = '${e.message}\n$diff';

        throw TestFailure(message);
      }

      await subscription.cancel();
      await verify?.call(bloc);
      await tearDown?.call();
    });
  } catch (e) {
    if (shallowEquality && e is TestFailure) {
      throw TestFailure(
        '''
${e.message}
WARNING: Please ensure presentation events extend Equatable, override == and hashCode, or implement Comparable.
Alternatively, consider using Matchers in the expectPresentation of the blocPresentationTest rather than concrete presentation events instances.\n''',
      );
    }

    rethrow;
  }
}

// Based on bloc_test package
Future<void> _runZonedGuarded(Future<void> Function() body) {
  final completer = Completer<void>();

  runZonedGuarded(
    () async {
      await body();

      if (!completer.isCompleted) {
        completer.complete();
      }
    },
    (e, st) {
      if (!completer.isCompleted) {
        completer.completeError(e, st);
      }
    },
  );

  return completer.future;
}

// Based on bloc_test package
String _diff({required dynamic expected, required dynamic actual}) {
  final buffer = StringBuffer();
  final differences = diff(expected.toString(), actual.toString());

  buffer
    ..writeln('${'=' * 4} diff ${'=' * 40}')
    ..writeln()
    ..writeln(differences.toPrettyString())
    ..writeln()
    ..writeln('${'=' * 4} end diff ${'=' * 36}');

  return buffer.toString();
}

extension on List<Diff> {
  // Based on bloc_test package
  String toPrettyString() {
    String identical(String str) => '\u001b[90m$str\u001B[0m';
    String deletion(String str) => '\u001b[31m[-$str-]\u001B[0m';
    String insertion(String str) => '\u001b[32m{+$str+}\u001B[0m';

    final buffer = StringBuffer();

    for (final difference in this) {
      switch (difference.operation) {
        case DIFF_EQUAL:
          buffer.write(identical(difference.text));
        case DIFF_DELETE:
          buffer.write(deletion(difference.text));
        case DIFF_INSERT:
          buffer.write(insertion(difference.text));
      }
    }

    return buffer.toString();
  }
}
