import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/mixins/DisplayableMessage.dart';
import 'package:gobz_app/models/BlocState.dart';

class BlocHandler<B extends BlocBase<S>, S extends BlocState> extends StatelessWidget {
  final Widget child;
  final String? errorMessage;
  final SnackBar Function(S state, BlocNotification notification)? snackbarBuilder;
  final BlocNotification? Function(S state)? mapErrorToNotification;

  const BlocHandler({
    Key? key,
    required this.child,
    this.errorMessage,
    this.mapErrorToNotification,
    this.snackbarBuilder,
  }) : super(key: key);

  factory BlocHandler.simple({required Widget child}) => BlocHandler(child: child);

  factory BlocHandler.custom({
    required Widget child,
    required BlocNotification? Function(S state) mapErrorToNotification,
  }) =>
      BlocHandler(
        child: child,
        mapErrorToNotification: mapErrorToNotification,
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listener: (context, state) {
        BlocNotification? notification;

        if (mapErrorToNotification != null) {
          notification = mapErrorToNotification!(state);
        }

        if (notification == null && state.isErrored) {
          if (state.error is DisplayableMessage) {
            notification = BlocNotification.error((state.error as DisplayableMessage).displayableMessage);
          } else {
            notification = BlocNotification.error(errorMessage ?? "Une erreur s'est produite");
          }
        }

        if (notification != null) {
          final SnackBar snackBar = snackbarBuilder?.call(state, notification) ??
              SnackBar(
                content: Text(
                  notification.message,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: notification.textColor),
                ),
                backgroundColor: notification.backgroundColor,
              );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      child: child,
    );
  }
}

class BlocNotification {
  final String message;
  final Color? backgroundColor;
  final Color? textColor;

  const BlocNotification._(this.message, {this.backgroundColor, this.textColor = Colors.white});

  factory BlocNotification.error(String message) => BlocNotification._(message, backgroundColor: Colors.redAccent);

  factory BlocNotification.success(String message) => BlocNotification._(message, backgroundColor: Colors.greenAccent);

  factory BlocNotification.warning(String message) => BlocNotification._(message, backgroundColor: Colors.orangeAccent);

  factory BlocNotification.custom(String message, Color backgroundColor, Color textColor) => BlocNotification._(
        message,
        backgroundColor: backgroundColor,
        textColor: textColor,
      );
}
