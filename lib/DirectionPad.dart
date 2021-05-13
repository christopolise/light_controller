import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

class DirectionPad extends StatefulWidget {
  // more state, can be exposed.
  // where the state goes.
  // final double value;
  Color color;

  // type signature for callbacks that report a value change.
  // see https://api.flutter.dev/flutter/foundation/ValueChanged.html
// Overrides the listener, whatever function is passed into this will be what is called
  // final ValueChanged<double> onChanged;

  double rangeLow;
  double rangeHigh;

  double radius;

  DirectionPad (

      // required named parameter <-- fail.
      // spoiler alert: inside {}s so not required.
      // this.value,
      // this.onChanged,

      {this.radius}

      // {this.radius = 15,
      //   this.color,
      //   this.rangeLow = 0,
      //   this.rangeHigh = 100,}
  );

  @override
  _DirectionPadState createState() => _DirectionPadState();
}
// the state for the curved slider
class _DirectionPadState extends State<DirectionPad> {
  
  bool isUp = false;
  bool isDown = false;
  bool isLeft = false;
  bool isRight = false;
  PointerEvent touchLocation;

  // and helper functions go here too.
  // where interaction is defined for real. This is where the callback finally
  // gets called.

  bool _pressUp(PointerEvent details){
    print("UP");
    return true;
    // return (details.localPosition.dx >= widget.)
  }

  bool _pressDown(PointerEvent details){
    return true;
  }

  bool _pressLeft(PointerEvent details){
    return true;
  }

  bool _pressRight(PointerEvent details){
    return true;
  } 

  void _fingerDown(PointerEvent details)
  {
    setState(() {

      // widget.onChanged((sliderProg- 49)/240);
       
      if(_pressUp(details)) isUp = true;
      if(_pressDown(details)) isDown = true;
      if(_pressLeft(details)) isLeft = true;
      if(_pressRight(details)) isRight = true;

    });
  }

  void _fingerUp(PointerEvent details)
  {
    setState(() {

      if(isUp) isUp = false;
      if(isDown) isDown = false;
      if(isLeft) isLeft = false;
      if(isRight) isRight = false;

      // widget.onChanged((sliderProg- 49)/240);
      
    });
  }

  // the heart of the curved slider.
  @override
  Widget build(BuildContext context) {
    return
      Container(
          width: double.infinity,
          height: 500,
          // color: Colors.red,
          child: Listener(
            // where the interaction starts.
            // probably want to handle other pointer events.
            onPointerDown: _fingerDown,
            onPointerUp: _fingerUp,
            child: CustomPaint (
              // call painter constructor with parameters.
              // such as state for the paint algorithms.
                painter: DirectionPadPainter(
                  // dPadColor: Colors.green,
                  upListener: this.isUp,
                  downListener: this.isDown,
                  leftListener: this.isLeft,
                  rightListener: this.isRight,
                  // touchLocation: 
                )
            ),
          )
      );
  }
}

// Custom painter widget for the CurvedSlider
class DirectionPadPainter extends CustomPainter
{
  // Color thumbColor;
  
  double radius;
  bool upListener;
  bool downListener;
  bool leftListener;
  bool rightListener;
  Color dPadColor;
  PointerEvent touchLocation;
  
  DirectionPadPainter(
    {this.radius,
    this.upListener,
    this.downListener,
    this.leftListener,
    this.rightListener,
    this.dPadColor,
    this.touchLocation}
  );

  // static Size getSize() { return size; }

  // static void setSize(Size newSize) { size = newSize; }

  @override
  void paint(Canvas canvas, Size size)
  {
    
    radius ??= 225;
    dPadColor ??= Color.fromRGBO(60, 60, 60, 1);

    Color dPadButCol = Color.fromRGBO(dPadColor.red - 40,
                                      dPadColor.green - 40, 
                                      dPadColor.blue - 40, 
                                      dPadColor.opacity);

    Color butPressed = Color.fromRGBO(dPadColor.red + 100,
                                      dPadColor.green + 0,
                                      dPadColor.blue + 0, 
                                      dPadColor.opacity);
    
    final dx = size.width / 2;
    final dy = size.height / 2;

    RRect vertRect = RRect.fromLTRBR(dx - ((1/3) * radius), (2/9) * radius, dx + ((1/3) * radius), size.height - ((2/9) * radius), Radius.circular(25));
    RRect horizRect = RRect.fromLTRBR(dx - ((200/225) * radius), dy - ((1/3) * radius), dx + ((200/225) * radius), dy + ((1/3) * radius), Radius.circular(25));

    Path TTriangle = Path();
    TTriangle.moveTo(dx, (1/3) * radius);
    TTriangle.lineTo(dx - 30, 115);
    TTriangle.lineTo(dx + 30, 115);
    TTriangle.close();

    Path BTriangle = Path();
    BTriangle.moveTo(dx, size.height - (1/3) * radius);
    BTriangle.lineTo(dx - 30, size.height - 115);
    BTriangle.lineTo(dx + 30, size.height - 115);
    BTriangle.close();

    Path LTriangle = Path();
    LTriangle.moveTo(dx - 175 , dy);
    LTriangle.lineTo(dx - 135, dy - 30);
    LTriangle.lineTo(dx - 135, dy + 30);
    LTriangle.close();

    Path RTriangle = Path();
    RTriangle.moveTo(dx + 175 , dy);
    RTriangle.lineTo(dx + 135, dy - 30);
    RTriangle.lineTo(dx + 135, dy + 30);
    RTriangle.close();

    Path TLTriangle = Path();
    TLTriangle.moveTo(dx + 175 , dy);
    TLTriangle.lineTo(dx + 135, dy - 30);
    TLTriangle.lineTo(dx + 135, dy + 30);
    TLTriangle.close();

    var dPadBody = Paint()
      ..color = dPadColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    var dPadButton = Paint()
      ..color = dPadButCol
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 10;

    
    var dPadPressed = Paint()
      ..color = butPressed
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    
    canvas.drawCircle(Offset(dx, dy), radius, dPadBody);
    canvas.drawRRect(vertRect, dPadButton);
    canvas.drawRRect(horizRect, dPadButton);
    canvas.drawPath(TTriangle, upListener ? dPadPressed : dPadBody);
    canvas.drawPath(BTriangle, downListener ? dPadPressed : dPadBody);
    canvas.drawPath(LTriangle, leftListener? dPadPressed : dPadBody);
    canvas.drawPath(RTriangle, rightListener? dPadPressed : dPadBody);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}