import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).backgroundColor,
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor)),
        ),
        Container(
            height: 60,
            width: 60,
            margin: EdgeInsets.only(top: 15, left: 15),
            child: Image.asset('assets/images/icon-loading.png'))
      ],
    );
  }
}
