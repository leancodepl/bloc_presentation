import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_presentation_mixin.dart';

class BlocPresentationListener<B extends BlocPresentation<E, S>, S, E>
    extends StatefulWidget {
  const BlocPresentationListener({
    Key key,
    this.cubit,
    @required this.listener,
    @required this.child,
  }) : super(key: key);

  final B cubit;
  final void Function(BuildContext, E, S) listener;
  final Widget child;

  @override
  _BlocPresentationListenerState<B, S, E> createState() =>
      _BlocPresentationListenerState<B, S, E>();
}

class _BlocPresentationListenerState<B extends BlocPresentation<E, S>, S, E>
    extends State<BlocPresentationListener<B, S, E>> {
  StreamSubscription _subscription;
  B _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.cubit ?? context.read<B>();
    _subscribe();
  }

  @override
  void didUpdateWidget(BlocPresentationListener<B, S, E> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldCubit = oldWidget.cubit ?? context.read<B>();
    final currentCubit = widget.cubit ?? oldWidget;
    if (oldCubit != currentCubit) {
      if (_subscription != null) {
        _unsubscribe();
      }

      _cubit = currentCubit;
      _subscribe();
    }
  }

  void _subscribe() {
    if (_cubit != null) {
      _subscription = _cubit.presentation.listen((event) {
        widget.listener(context, event, _cubit.state);
      });
    }
  }

  void _unsubscribe() {
    _subscription.cancel();
    _subscription = null;
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }
}
