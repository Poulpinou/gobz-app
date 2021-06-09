import 'package:flutter/material.dart';
import 'package:gobz_app/data/mixins/DisplayableMessage.dart';

class FetchFailure extends StatelessWidget {
  final String message;
  final Function? retryFunction;
  final String? retryMessage;
  final Exception? error;

  const FetchFailure({Key? key, required this.message, this.retryFunction, this.retryMessage, this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? errorMessage;
    if (error is DisplayableMessage) {
      errorMessage = (error as DisplayableMessage).displayableMessage;
    } else {
      errorMessage = null;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(message),
          errorMessage != null ? Text(errorMessage) : Container(),
          retryFunction != null
              ? ElevatedButton(
                  onPressed: retryFunction!(),
                  child: Text(retryMessage ?? "Réessayer"),
                )
              : Container(),
        ],
      ),
    );
  }
}
