import 'package:flutter/material.dart';

class ErrorRetryWidget extends StatefulWidget {
  final String errorMsg;
  final Function onPressed;

  ErrorRetryWidget({this.errorMsg, @required this.onPressed})
      : assert(onPressed != null);

  @override
  _ErrorRetryWidgetState createState() => _ErrorRetryWidgetState();
}

class _ErrorRetryWidgetState extends State<ErrorRetryWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('获取体系数据失败。请点击重试.\n${widget.errorMsg}'),
        ),
        FlatButton(
            onPressed: () {
              widget.onPressed();
            },
            child: Text(
              "重试",
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );
  }
}
