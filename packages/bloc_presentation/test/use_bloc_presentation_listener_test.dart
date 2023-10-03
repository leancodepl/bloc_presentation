import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'fakes.dart';

class _TestCubit extends Cubit<int>
    with BlocPresentationMixin<int, _PresentationEvent> {
  _TestCubit() : super(0);

  void emitEvent(_PresentationEvent event) => emitPresentation(event);
}

class _PresentationEvent {}

class _MockListener extends Mock {
  void call(
    BuildContext context,
    _PresentationEvent event,
  );
}

void main() {
  group('useBlocPresentationListener', () {
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
        Provider<_TestCubit>.value(
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
  });
}
