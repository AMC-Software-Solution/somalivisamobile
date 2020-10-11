import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(value: null),
                  Padding(padding: EdgeInsets.only(top: 15),),
                Text('Loading...', style: Theme.of(context).textTheme.bodyText1,)
            ]),
          ),
        ),
      ),
    );
  }
}
