import 'package:flutter/material.dart';

class UnaryOperatorButton extends StatelessWidget {

  UnaryOperatorButton({this.text,this.onPressed});

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          constraints: BoxConstraints.tight(Size(60.0, 60.0)),
          onPressed:onPressed,
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          fillColor: Colors.grey,
        ));
  }
}
