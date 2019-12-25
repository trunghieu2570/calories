import 'package:flutter/material.dart';

class LoadingStack extends StatelessWidget {
  final Widget body;
  final bool state;

  LoadingStack({Key key, this.body, this.state})
      : assert(body != null),
        assert(state != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.loose,
      overflow: Overflow.clip,
      children: <Widget>[
        body,
        state
            ? Opacity(
                child: ModalBarrier(dismissible: false, color: Colors.black),
                opacity: 0.40,
              )
            : Container(),
        state
            ? Container(
                child: CircularProgressIndicator(),
              )
            : Container(),
      ],
    );
  }
}
