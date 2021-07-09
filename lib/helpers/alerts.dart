part of 'helpers.dart';

showLoading(BuildContext context) {
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (_) { 
      if (Platform.isAndroid) {
        return AlertDialog(
          title: Text('Espere...'),
          content: LinearProgressIndicator(),
        );
      }
      return CupertinoAlertDialog(
        title: Text('Espere...'),
        content: LinearProgressIndicator(),
      );
    },  
  );
}

showAlert(BuildContext context, String title, String message) {
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (_) { 
      if (Platform.isAndroid) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            MaterialButton(
              child: Text('Ok'),
              onPressed: () => Navigator.pop(context)
            )
          ],
        );
      }
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          MaterialButton(
            child: Text('Ok'),
            onPressed: () => Navigator.pop(context)
          )
        ],
      );
    },  
  );
}