import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "الرئيسية",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: "طلباتي",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: "المفضلة",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "حسابي",
        ),
      ],
    );
  }
}