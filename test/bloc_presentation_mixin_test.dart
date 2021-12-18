import 'package:bloc/bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestCubit extends Cubit<int> with BlocPresentationMixin {
  _TestCubit() : super(0);

  void emitValueEvent() => emitPresentation(_ValueEvent());
  void emitReferenceEvent() => emitPresentation(_ReferenceEvent());
}

class _ValueEvent implements BlocPresentationEvent {
  @override
  bool operator ==(Object other) => other is _ValueEvent;

  @override
  int get hashCode => 0;
}

class _ReferenceEvent implements BlocPresentationEvent {}

void main() {
  group('BlocPresentationMixin', () {
    late _TestCubit cubit;

    setUp(() {
      cubit = _TestCubit();
    });

    test('Presentation events are emitted', () {
      expect(
        cubit.presentation,
        emitsInOrder(<Matcher>[
          isA<_ValueEvent>(),
          isA<_ReferenceEvent>(),
        ]),
      );

      cubit
        ..emitValueEvent()
        ..emitReferenceEvent();
    });

    test('Presentation stream is correctly closed', () async {
      expect(
        cubit.presentation,
        emitsInOrder(<Matcher>[
          isA<_ValueEvent>(),
          emitsDone,
        ]),
      );

      cubit.emitValueEvent();
      await cubit.close();

      expect(cubit.emitReferenceEvent, throwsStateError);
      expect(() => cubit.emit(0), throwsStateError);
    });

    test('Presentation stream can emit consecutively equal objects', () async {
      expect(
        cubit.presentation,
        emitsInOrder(<Matcher>[
          isA<_ValueEvent>(),
          isA<_ValueEvent>(),
          isA<_ReferenceEvent>(),
          isA<_ReferenceEvent>(),
        ]),
      );

      cubit
        ..emitValueEvent()
        ..emitValueEvent()
        ..emitReferenceEvent()
        ..emitReferenceEvent();
    });
  });
}
