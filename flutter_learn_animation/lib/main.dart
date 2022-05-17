import 'package:flutter/material.dart';

import 'package:flutter_learn_animation/battery_screen.dart';
import 'package:flutter_learn_animation/bottom_navigation.dart';
import 'package:flutter_learn_animation/kekers/kekers_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentTab = TabItem.kekers;



  void _selectTab(TabItem item) {
    //print(index);
    setState(() => _currentTab = item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: _currentTab!=TabItem.battery,
            child: const BatteryPage(),
          ),
          Offstage(
            offstage: _currentTab!=TabItem.kekers,
            child: const KekersPage(),
          )
        ],
      ),
      bottomNavigationBar: MyBottomNavigation(
        currentTab: _currentTab,
        onSelectTab: _selectTab,
      ),
    );
  }
}
