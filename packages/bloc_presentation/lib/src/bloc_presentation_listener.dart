import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import 'bloc_presentation_mixin.dart';

/// Signature for the `listener` function which takes the `BuildContext` along
/// with the `event` and is responsible for executing in response to
/// new events.
typedef BlocPresentationWidgetListener<P> = void Function(
  BuildContext context,
  P event,
);

/// A widget that listens to events from a Bloc and invokes a listener
/// function in response to new events.
///
/// This widget is used to interact with [BlocPresentationMixin] and listen
/// to events of type [P]. When a new event of type [P] is emitted by the Bloc,
/// the provided [listener] function is called with the current [BuildContext]
/// and the event itself.
///
/// Example:
/// ```dart
/// BlocPresentationListener<MyBloc, MyEvent>(
///   listener: (context, event) {
///     // Handle the event here
///   },
///   bloc: myBloc, // You don't have to pass it if you provided it in context
///   child: SomeWidget(),
/// )
/// ```
class BlocPresentationListener<B extends BlocPresentationMixin<dynamic, P>, P>
    extends SingleChildStatefulWidget {
  /// Creates a [BlocPresentationListener].
  ///
  /// The [listener] function is required and will be called with the
  /// current [BuildContext] and the event of type [P] when new events are
  /// emitted by the Bloc.
  ///
  /// The [bloc] parameter is optional and can be used to specify the
  /// Bloc to listen to. If not provided, the nearest ancestor Bloc of
  /// type [B] in the widget tree will be used.
  ///
  /// The [child] parameter is optional and represents the child widget
  /// to display. If not provided, an empty [SizedBox] is used as the child.
  const BlocPresentationListener({
    super.key,
    required this.listener,
    this.bloc,
    this.child,
  }) : super(child: child);

  /// A function that defines the behavior when a new event of type [P] is
  /// emitted by the Bloc. It takes the current [BuildContext] and the
  /// event itself as parameters and is responsible for handling the event.
  final BlocPresentationWidgetListener<P> listener;

  /// The Bloc from which to listen to events of type [P]. If not provided,
  /// the nearest ancestor Bloc of type [B] in the widget tree will be used.
  final B? bloc;

  /// An optional child widget to display within the [BlocPresentationListener].
  /// If not provided, an empty [SizedBox] is used as the child.
  final Widget? child;

  @override
  SingleChildState<BlocPresentationListener<B, P>> createState() =>
      _BlocPresentationListenerBaseState<B, P>();
}

class _BlocPresentationListenerBaseState<
    B extends BlocPresentationMixin<dynamic, P>,
    P> extends SingleChildState<BlocPresentationListener<B, P>> {
  StreamSubscription<P>? _streamSubscription;
  late B _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = _bloc = widget.bloc ?? context.read<B>();

    _subscribe();
  }

  @override
  void didUpdateWidget(BlocPresentationListener<B, P> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;

    if (oldBloc != currentBloc) {
      if (_streamSubscription != null) {
        _unsubscribe();
        _bloc = currentBloc;
      }

      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = widget.bloc ?? context.read<B>();

    if (_bloc != bloc) {
      if (_streamSubscription != null) {
        _unsubscribe();
        _bloc = bloc;
      }

      _subscribe();
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return child ?? const SizedBox();
  }

  @override
  void dispose() {
    _unsubscribe();

    super.dispose();
  }

  void _subscribe() {
    _streamSubscription = _bloc.presentation.listen(
      (event) => widget.listener(context, event),
    );
  }

  void _unsubscribe() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }
}
