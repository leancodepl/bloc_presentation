import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'fakes.dart';

class _TestCubit extends Cubit<int>
    with BlocPresentationMixin<int, _PresentationEvent> {
  _TestCubit() : super(0);

  void emitEvent(_PresentationEvent event) => emitPresentation(event);
}

class _PresentationEvent {}

class _MockListener extends Mock {
  void call(BuildContext context, _PresentationEvent event);
}

void main() {
  group('BlocPresentationListener', () {
    late _TestCubit cubit;
    late BlocPresentationWidgetListener<_PresentationEvent> listener;
    late _PresentationEvent event;

    setUpAll(() {
      registerFakes();
      registerFallbackValue(_PresentationEvent());
    });

    setUp(() {
      cubit = _TestCubit();
      listener = _MockListener();
      event = _PresentationEvent();

      when(() => listener(any(), any())).thenReturn(null);
    });

    testWidgets('Correctly calls the provided listener', (tester) async {
      await tester.pumpWidget(
        BlocPresentationListener(
          bloc: cubit,
          listener: listener,
          child: const SizedBox(),
        ),
      );

      cubit.emitEvent(event);

      await tester.pump();

      verify(() => listener(any(), event)).called(1);
    });

    testWidgets('Correctly fallsback to the Provider cubit', (tester) async {
      await tester.pumpWidget(
        BlocProvider<_TestCubit>.value(
          value: cubit,
          child: BlocPresentationListener<_TestCubit, _PresentationEvent>(
            listener: listener,
            child: const SizedBox(),
          ),
        ),
      );

      cubit.emitEvent(event);

      await tester.pump();

      verify(() => listener(any(), event)).called(1);
    });

    testWidgets('Correctly disposes listener', (tester) async {
      await tester.pumpWidget(
        BlocPresentationListener<_TestCubit, _PresentationEvent>(
          bloc: cubit,
          listener: listener,
          child: const SizedBox(),
        ),
      );

      cubit.emitEvent(event);

      await tester.pump();

      await tester.pumpWidget(const SizedBox());

      cubit.emitEvent(event);

      await tester.pump();

      verify(() => listener(any(), event)).called(1);
    });

    testWidgets('Updates dependencies', (tester) async {
      await tester.pumpWidget(
        BlocPresentationListener<_TestCubit, _PresentationEvent>(
          bloc: cubit,
          listener: listener,
          child: const SizedBox(),
        ),
      );

      cubit.emitEvent(event);
      await tester.pump();

      await tester.pumpWidget(
        BlocPresentationListener<_TestCubit, _PresentationEvent>(
          bloc: cubit,
          listener: listener,
          child: const SizedBox(),
        ),
      );

      cubit.emitEvent(event);
      await tester.pump();

      verify(() => listener(any(), event)).called(2);

      final cubit2 = _TestCubit();

      await tester.pumpWidget(
        BlocPresentationListener<_TestCubit, _PresentationEvent>(
          bloc: cubit2,
          listener: listener,
          child: const SizedBox(),
        ),
      );

      cubit2.emitEvent(event);
      cubit.emitEvent(event);
      await tester.pump();

      verify(() => listener(any(), event)).called(1);

      final listener2 = _MockListener();

      await tester.pumpWidget(
        BlocPresentationListener<_TestCubit, _PresentationEvent>(
          bloc: cubit2,
          listener: listener2,
          child: const SizedBox(),
        ),
      );

      cubit2.emitEvent(event);
      await tester.pump();

      verifyNever(() => listener(any(), event));
      verify(() => listener2(any(), event)).called(1);
    });

    testWidgets('listens to events if bloc instance changed', (tester) async {
      final cubit1 = _TestCubit();
      final cubit2 = _TestCubit();

      await tester.pumpWidget(
        BlocProvider<_TestCubit>.value(
          value: cubit1,
          child: BlocPresentationListener<_TestCubit, _PresentationEvent>(
            listener: listener,
            child: const SizedBox(),
          ),
        ),
      );

      // Pass new instance of the cubit
      await tester.pumpWidget(
        BlocProvider<_TestCubit>.value(
          value: cubit2,
          child: BlocPresentationListener<_TestCubit, _PresentationEvent>(
            listener: listener,
            child: const SizedBox(),
          ),
        ),
      );

      cubit2.emitEvent(event);
      await tester.pump();

      verify(() => listener(any(), event)).called(1);
    });

    testWidgets(
      'does nothing when no bloc in context and type parameter is nullable',
      (tester) async {
        await tester.pumpWidget(
          BlocPresentationListener<_TestCubit?, _PresentationEvent>(
            // bloc not provided and no provider in the tree
            listener: listener,
            child: const SizedBox(),
          ),
        );

        await tester.pump();

        verifyNever(() => listener(any(), any()));
      },
    );

    testWidgets(
      'attaches when provider appears on second pump',
      (tester) async {
        final key = GlobalKey();
        final cubitInContext = _TestCubit();

        // First pump: no provider in the tree
        await tester.pumpWidget(
          BlocPresentationListener<_TestCubit?, _PresentationEvent>(
            key: key,
            listener: listener,
            child: const SizedBox(),
          ),
        );

        // Verify no calls when there is no provider
        await tester.pump();
        verifyNever(() => listener(any(), any()));

        // Second pump: insert provider above the same keyed listener
        await tester.pumpWidget(
          BlocProvider<_TestCubit>.value(
            value: cubitInContext,
            child: BlocPresentationListener<_TestCubit?, _PresentationEvent>(
              key: key,
              listener: listener,
              child: const SizedBox(),
            ),
          ),
        );

        cubitInContext.emitEvent(event);

        await tester.pump();

        verify(() => listener(any(), event)).called(1);
      },
    );
  });
}
