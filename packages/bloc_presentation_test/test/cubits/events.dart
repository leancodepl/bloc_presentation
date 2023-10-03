import 'package:equatable/equatable.dart';

sealed class CounterPresentationEvent extends Equatable {
  const CounterPresentationEvent(this.number);

  final int number;
}

final class InitialPresentationEvent extends CounterPresentationEvent {
  const InitialPresentationEvent(super.number);

  @override
  List<Object?> get props => [number];
}

final class IncrementPresentationEvent extends CounterPresentationEvent {
  const IncrementPresentationEvent(super.number);

  @override
  List<Object?> get props => [number];
}

sealed class NonEquatableCounterPresentationEvent {
  const NonEquatableCounterPresentationEvent(this.number);

  final int number;
}

final class NonEquatableIncrementPresentationEvent
    extends NonEquatableCounterPresentationEvent {
  const NonEquatableIncrementPresentationEvent(super.number);
}
