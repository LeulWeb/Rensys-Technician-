import 'package:flutter/material.dart';

class SnackBarPage extends StatelessWidget {
  const SnackBarPage({Key? key}) : super(key: key);



  void showSnackBar(BuildContext context) {
    final snackBar =  SnackBar(
      content: Text('Hi, Flutter developers'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        child: Text('Show Snackbar'),
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () {
          showSnackBar(context);
        },
      ),
    );
  }
}
