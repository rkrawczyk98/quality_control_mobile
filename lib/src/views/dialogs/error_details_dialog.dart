import 'package:flutter/material.dart';

class ErrorDetailsDialog extends StatelessWidget {
  final String errorMessage;
  final String errorCode;

  const ErrorDetailsDialog({
    super.key,
    required this.errorMessage,
    this.errorCode = "",
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Szczegóły błędu'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Wiadomość: $errorMessage'),
            if (errorCode.isNotEmpty) Text('Kod błędu: $errorCode'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Zamknij'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
