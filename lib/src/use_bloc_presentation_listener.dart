import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

void useBlocPresentationListener<C extends BlocPresentationMixin<Object>>({
  required BlocPresentationWidgetListener listener,
  C? cubit,
}) {
  final context = useContext();

  useEffect(
    () {
      final effectiveStream =
          cubit?.presentation ?? context.read<C>().presentation;

      final subscription = effectiveStream.listen(
        (event) => listener(context, event),
      );

      return subscription.cancel;
    },
    [cubit, listener],
  );
}
