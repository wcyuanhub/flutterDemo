import 'package:flutter/material.dart';
import 'package:flutter_project/contants/baseContant.dart';
import 'package:flutter_project/views/cart/index.dart';
import 'package:flutter_project/views/category/index.dart';
import 'package:flutter_project/views/home/index.dart';
import 'package:flutter_project/views/me/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Map<String, dynamic>> _tabs = [
    {"name": "首页", "icon": "home_normal.png", "activeIcon": "home_active.png"},
    {"name": "分类", "icon": "pro_normal.png", "activeIcon": "pro_active.png"},
    {"name": "购物车", "icon": "cart_normal.png", "activeIcon": "cart_active.png"},
    {"name": "我的", "icon": "my_normal.png", "activeIcon": "my_active.png"},
  ];

  List<BottomNavigationBarItem> _getTabs() {
    return List.generate(_tabs.length, (index) {
      return BottomNavigationBarItem(
        label: _tabs[index]["name"],
        icon: Image.asset(
          "$imagePath${_tabs[index]["icon"]}",
          width: 24,
          height: 24,
        ),
        activeIcon: Image.asset(
          "$imagePath${_tabs[index]["activeIcon"]}",
          width: 24,
          height: 24,
        ),
      );
    });
  }

  List<Widget> _getPages() {
    return List.generate(_tabs.length, (index) {
      return _tabs[index]["name"] == "首页"
          ? const HomePage()
          : _tabs[index]["name"] == "分类"
          ? const CategoryPage()
          : _tabs[index]["name"] == "购物车"
          ? const CartPage()
          : const MePage();
    });
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _getPages()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          _currentIndex = index;
          setState(() {});
        },
        currentIndex: _currentIndex,
        items: _getTabs(),
      ),
    );
  }
}
