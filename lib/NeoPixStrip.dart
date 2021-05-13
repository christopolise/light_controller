import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

class NeoPixStrip extends StatefulWidget {
  // more state, can be exposed.
  // where the state goes.
  // final double value;
  // Color color;

  // type signature for callbacks that report a value change.
  // see https://api.flutter.dev/flutter/foundation/ValueChanged.html
// Overrides the listener, whatever function is passed into this will be what is called
  // final LedChanged<int> onChanged;

  // double rangeLow;
  // double rangeHigh;

  // double radius;

  NeoPixStrip (
      // {this.radius}
  );

  @override
  _NeoPixStripState createState() => _NeoPixStripState();
}
// the state for the curved slider
class _NeoPixStripState extends State<NeoPixStrip> {
  
  bool isUp = false;
  bool isDown = false;
  bool isLeft = false;
  bool isRight = false;
  PointerEvent touchLocation;

  // and helper functions go here too.
  // where interaction is defined for real. This is where the callback finally
  // gets called.

  void _fingerDown(PointerEvent details)
  {
    setState(() {

      // widget.onChanged((sliderProg- 49)/240);

    });
  }

  void _fingerUp(PointerEvent details)
  {
    setState(() {

      // widget.onChanged((sliderProg- 49)/240);
      
    });
  }

  // the heart of the curved slider.
  @override
  Widget build(BuildContext context) {
    return
      Container(
          width: 2000,
          height: 25,
          // color: Colors.red,
          child: Listener(
            // where the interaction starts.
            // probably want to handle other pointer events.
            onPointerDown: _fingerDown,
            onPointerUp: _fingerUp,
            child: CustomPaint (
              // call painter constructor with parameters.
              // such as state for the paint algorithms.
                painter: NeoPixStripPainter(

                  
                )
            ),
          )
      );
  }
}

// Custom painter widget for the CurvedSlider
class NeoPixStripPainter extends CustomPainter
{

  int ledInd;
  Color col;
  String mode;

  NeoPixStripPainter(
    {
      this.ledInd,
      this.col,
      this.mode
    }
  );

  // static Size getSize() { return size; }

  // static void setSize(Size newSize) { size = newSize; }

  @override
  void paint(Canvas canvas, Size size)
  {

    ledInd ??= 0;
    col ??= Colors.blue;


    var backPaint = Paint()
      ..color = Colors.black;

    var forePaint = Paint()
      ..color = Colors.red;

    var drawLed = Paint()
      ..color = col;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backPaint);
    
    for(int i = 0; i < 144; i++)
    {
      canvas.drawCircle(Offset(size.width/144 * i + 5, size.height/2), 5, forePaint);  
    }

    canvas.drawCircle(Offset(size.width/144 * ledInd + 5, size.height/2), 5, drawLed);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}