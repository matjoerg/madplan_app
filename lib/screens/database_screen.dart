import 'package:flutter/cupertino.dart';

class DatabaseScreen extends StatelessWidget {
  const DatabaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('Shopping Cart'),
        ),
      ],
    );
  }
}
