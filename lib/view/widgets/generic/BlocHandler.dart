import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/BlocState.dart';
import 'package:gobz_app/data/mixins/DisplayableMessage.dart';

class BlocHandler<B extends BlocBase<S>, S extends BlocState> extends StatelessWidget {
  final Widget child;
  final String? errorMessage;
  final SnackBar Function(S state, BlocNotification notification)? snackbarBuilder;
  final BlocNotification? Function(S state)? mapEventToNotification;

  const BlocHandler({
    Key? key,
    required this.child,
    this.errorMessage,
    this.mapEventToNotification,
    this.snackbarBuilder,
  }) : super(key: key);

  factory BlocHandler.simple({required Widget child}) => BlocHandler(child: child);

  factory BlocHandler.custom({
    required Widget child,
    required BlocNotification? Function(S state) mapEventToNotification,
  }) =>
      BlocHandler(
        child: child,
        mapEventToNotification: mapEventToNotification,
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listener: (context, state) {
        BlocNotification? notification;

        if (mapEventToNotification != null) {
          notification = mapEventToNotification!(state);
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

          notification.postAction?.call(context);
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
  final Function(BuildContext context)? postAction;

  const BlocNotification._(this.message, {this.backgroundColor, this.textColor = Colors.white, this.postAction});

  factory BlocNotification.error(String message) => BlocNotification._(message, backgroundColor: Colors.redAccent);

  factory BlocNotification.success(String message) => BlocNotification._(message, backgroundColor: Colors.greenAccent);

  factory BlocNotification.warning(String message) => BlocNotification._(message, backgroundColor: Colors.orangeAccent);

  BlocNotification copyWith({
    String? message,
    Color? backgroundColor,
    Color? textColor,
    Function(BuildContext context)? postAction,
  }) =>
      BlocNotification._(
        message ?? this.message,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        textColor: textColor ?? this.textColor,
        postAction: postAction ?? this.postAction,
      );

  BlocNotification withPostAction(Function(BuildContext context) action) => copyWith(postAction: action);
}
