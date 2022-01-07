/// {@template bloc_presentation_event}
/// Marker type all presentation events.
///
/// Implement it for your events:
///
/// ```dart
/// class FailedActionEvent implements BlocPresentationEvent {
///   const FailedActionEvent(this.errorMessage);
///
///   final String errorMessage;
/// }
/// ```
/// {@endtemplate}
abstract class BlocPresentationEvent {
  /// {@macro bloc_presentation_event}
  const BlocPresentationEvent();
}
