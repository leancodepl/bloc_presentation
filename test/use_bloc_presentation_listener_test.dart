import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'fakes.dart';

class _TestCubit extends Cubit<int> with BlocPresentationMixin {
  _TestCubit() : super(0);

  void emitEvent(BlocPresentationEvent event) => emitPresentation(event);
}

class _PresentationEvent implements BlocPresentationEvent {}

class _MockListener extends Mock {
  void call(
    BuildContext context,
    BlocPresentationEvent event,
  );
}

void main() {
  group('useBlocPresentationListener', () {
    late _TestCubit cubit;
    late BlocPresentationWidgetListener listener;
    late BlocPresentationEvent event;
    late HookElement element;

    setUpAll(registerFakes);

    setUp(() {
      cubit = _TestCubit();
      listener = _MockListener();
      event = _PresentationEvent();

      when(() => listener(any(), any())).thenReturn(null);
    });

    testWidgets('Correctly calls the provided listener', (tester) async {
      await tester.pumpWidget(HookBuilder(
        builder: (context) {
          element = context as HookElement;
          useBlocPresentationListener(
            listener: listener,
            cubit: cubit,
          );

          return Container();
        },
      ));

      cubit.emitEvent(event);

      await tester.pump();

      verify(() => listener(any(), event)).called(1);
      expect(element.dirty, false);
    });

    testWidgets('Correctly fallsback to the Provider cubit', (tester) async {
      await tester.pumpWidget(Provider<_TestCubit>.value(
        value: cubit,
        child: HookBuilder(
          builder: (context) {
            element = context as HookElement;
            useBlocPresentationListener<_TestCubit>(listener: listener);

            return Container();
          },
        ),
      ));

      cubit.emitEvent(event);

      await tester.pump();

      verify(() => listener(any(), event)).called(1);
      expect(element.dirty, false);
    });

    testWidgets('Correctly disposes listener', (tester) async {
      await tester.pumpWidget(HookBuilder(
        builder: (context) {
          useBlocPresentationListener(
            listener: listener,
            cubit: cubit,
          );

          return Container();
        },
      ));

      cubit.emitEvent(event);

      await tester.pump();

      await tester.pumpWidget(const SizedBox());
      cubit.emitEvent(event);
      await tester.pump();

      verify(() => listener(any(), event)).called(1);
    });

    testWidgets('Updates dependencies', (tester) async {
      await tester.pumpWidget(HookBuilder(
        builder: (context) {
          useBlocPresentationListener(
            listener: listener,
            cubit: cubit,
          );

          return Container();
        },
      ));

      cubit.emitEvent(event);
      await tester.pump();

      await tester.pumpWidget(HookBuilder(
        builder: (context) {
          useBlocPresentationListener(
            listener: listener,
            cubit: cubit,
          );

          return Container();
        },
      ));

      cubit.emitEvent(event);
      await tester.pump();

      verify(() => listener(any(), event)).called(2);

      final cubit2 = _TestCubit();

      await tester.pumpWidget(HookBuilder(
        builder: (context) {
          useBlocPresentationListener(
            listener: listener,
            cubit: cubit2,
          );

          return Container();
        },
      ));

      cubit2.emitEvent(event);
      cubit.emitEvent(event);
      await tester.pump();

      verify(() => listener(any(), event)).called(1);

      final listener2 = _MockListener();

      await tester.pumpWidget(HookBuilder(
        builder: (context) {
          useBlocPresentationListener(
            listener: listener2,
            cubit: cubit2,
          );

          return Container();
        },
      ));

      cubit2.emitEvent(event);
      await tester.pump();

      verifyNever(() => listener(any(), event));
      verify(() => listener2(any(), event)).called(1);
    });
  });
}
