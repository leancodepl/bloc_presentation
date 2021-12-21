import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

void useBlocPresentationListener<B extends BlocPresentationMixin<Object>>({
  required BlocPresentationWidgetListener listener,
  B? bloc,
}) {
  final context = useContext();

  useEffect(
    () {
      final effectiveStream =
          bloc?.presentation ?? context.read<B>().presentation;

      final subscription = effectiveStream.listen(
        (event) => listener(context, event),
      );

      return subscription.cancel;
    },
    [bloc, listener],
  );
}
