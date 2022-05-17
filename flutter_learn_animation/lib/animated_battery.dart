import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedBattery extends StatefulWidget {
  final int percent;
  final double width;
  final double height;
  const AnimatedBattery({Key? key,
   this.percent=20,
   this.width = 134,
   this.height = 334
   }) : super(key: key);

  @override
  State<AnimatedBattery> createState() => _AnimatedBatteryState();
}

class _AnimatedBatteryState extends State<AnimatedBattery> 
  with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _animationController.repeat();
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var borderRadius = Radius.elliptical((widget.width*0.3), widget.height*0.05);
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedWaveClip(
            controller: _animationController,
            child: AnimatedContainer(
              width: widget.width*0.986,
              height: widget.height*max(widget.percent*0.96/100, 0.1),
              duration: const Duration(seconds: 1),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    Colors.teal,
                    Colors.indigo,
                    Colors.yellow,
                    Colors.red,
                  ], //
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: borderRadius,
                  bottomRight: borderRadius)
                )
            ),
          ),
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: Image.asset('assets/images/battery_frame.png',fit: BoxFit.fill,),
          ),
        ],
      ),
    );
  }
}

class AnimatedWaveClip extends AnimatedWidget{
  final Widget? child;

  const AnimatedWaveClip({
    Key? key, 
    required AnimationController controller, 
    this.child
  }) : super(key: key,listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WavePainter(waveAnimation: _progress.value),
      child: child
    );
  }
}
class WavePainter extends CustomClipper<Path> {
  double waveAnimation;
  WavePainter({required this.waveAnimation});
  
  @override
  Path getClip(Size size) {
    var path = Path();
    //waveAnimation=1;
    /*for (double i = 0.0; i < size.width; i++) {
      path.lineTo(i,
          sin((i / size.width * 2 * pi) + (waveAnimation * 2 * pi)) * 4);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();*/

    var off = size.width*waveAnimation;
    var controlPoint = Offset((size.width*0.25)+off, 0);
    var endPoint = Offset(size.width*0.5+off, 6);
    var controlPoint2 = Offset(size.width*0.75+off, 10);
    var endPoint2 = Offset(size.width+off, 6);

    path.moveTo(size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.lineTo(0, 6);

    path.quadraticBezierTo(
        -size.width+(size.width*0.25)+off, 0, -size.width+(size.width*0.5)+off, 6);
    path.quadraticBezierTo(
        -size.width+(size.width*0.75)+off, 10, -size.width+(size.width)+off, 6);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.quadraticBezierTo(
        controlPoint2.dx, controlPoint2.dy, endPoint2.dx, endPoint2.dy);

    path.close();
  
    return path;
  }

  @override
  bool shouldReclip(WavePainter oldClipper) {
    return waveAnimation != oldClipper.waveAnimation;
  }
}
