import 'package:mqtt_web_app/DirectionPad.dart';
import 'package:flutter/material.dart';

class GameController extends StatefulWidget{
  GameController({Key key}) : super(key: key);

  @override
  _GameControllerState createState() => _GameControllerState();
}

class _GameControllerState extends State<GameController> {

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: DirectionPad()),
    );
  }
}