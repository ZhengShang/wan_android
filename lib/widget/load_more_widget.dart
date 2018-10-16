import 'package:flutter/material.dart';

class NoMoreDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Text(
        "没有更多数据了.",
        textAlign: TextAlign.center,
      ),
    );
  }
}

class LoadingMoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(12.0),
            child: SizedBox(
                width: 24.0, height: 24.0, child: CircularProgressIndicator())),
        Text("正在加载中...")
      ],
    );
  }
}

class LoadingFailedWidget extends StatelessWidget {
  final Function onRetryPressed;

  LoadingFailedWidget({this.onRetryPressed}) : assert(onRetryPressed != null);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FlatButton(
            onPressed: () {
              onRetryPressed();
            },
            child: Text("加载失败，请点击重试",
                style: TextStyle(
                  color: Colors.blue,
                ))));
  }
}
