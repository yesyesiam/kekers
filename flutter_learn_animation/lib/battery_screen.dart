import 'package:flutter/material.dart';
import 'package:flutter_learn_animation/animated_battery.dart';

class BatteryPage extends StatefulWidget {
  const BatteryPage({ Key? key }) : super(key: key);

  @override
  State<BatteryPage> createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage> {
  int p = 11;
  void _lowHeight() {
    setState(() {
      p=11;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Battery"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBattery(
              percent: p,
              width: MediaQuery.of(context).size.shortestSide*0.2,
              height: MediaQuery.of(context).size.shortestSide*0.4,
            ),
            ElevatedButton(onPressed: ()=>setState(()=>p=100), child: const Text("100"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _lowHeight,
        tooltip: 'Low',
        child: const Icon(Icons.remove),
      ),
    );
  }
}