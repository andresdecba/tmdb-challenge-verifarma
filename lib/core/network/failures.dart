import 'package:flutter/material.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';

abstract class Failure {
  void showError({VoidCallback? callback});

  static Failure getFailureFromString(String className) {
    if (className == (InvalidApiKeyFailure).toString()) {
      return InvalidApiKeyFailure();
    }

    if (className == (InvalidFormatFailure).toString()) {
      return InvalidFormatFailure();
    }

    if (className == (InternalErrorFailure).toString()) {
      return InternalErrorFailure();
    }
    return ServerFailure();
  }
}

class InvalidApiKeyFailure extends Failure {
  final BuildContext? context = rootNavigatorKey.currentContext;

  @override
  showError({VoidCallback? callback}) {
    showDialog<void>(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ERROR'),
          content: const Text('Invalid Api Key'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class InvalidFormatFailure extends Failure {
  @override
  showError({VoidCallback? callback}) {}
}

class InternalErrorFailure extends Failure {
  @override
  showError({VoidCallback? callback}) {}
}

class ServerFailure extends Failure {
  final BuildContext? context = rootNavigatorKey.currentContext;
  @override
  showError({VoidCallback? callback}) {
    showDialog<void>(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SERVER ERROR'),
          content: const Text('Algo salió mal :('),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
