import 'package:flutter/material.dart';

class MyTab {
  final String name;
  final MaterialColor color;
  final IconData icon;

  const MyTab({required this.name, required this.color, required this.icon});
}

enum TabItem { battery, kekers  }

const Map<TabItem, MyTab> tabs = {
  TabItem.battery : MyTab(name: "Battery", color: Colors.red, icon: Icons.battery_full_rounded),
  TabItem.kekers : MyTab(name: "Kekers", color: Colors.blue, icon: Icons.circle),
};


class MyBottomNavigation extends StatelessWidget {
  const MyBottomNavigation({ Key? key, required this.onSelectTab, required this.currentTab }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentTab.index,
      items: [
        BottomNavigationBarItem(
          icon: Icon(tabs[TabItem.battery]!.icon, color: tabs[TabItem.battery]!.color),
          label: tabs[TabItem.battery]!.name
        ),
        BottomNavigationBarItem(
          icon: Icon(tabs[TabItem.kekers]!.icon, color: tabs[TabItem.kekers]!.color,),
          label: tabs[TabItem.kekers]!.name
        ),
      ],
      onTap: (index)=>onSelectTab(TabItem.values[index]),
    );
  }
}