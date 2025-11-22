import 'package:esae_monie/presentation/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MainScreen extends HookWidget {
  static const String routeName = 'main';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    final screens = [
      Home(),
      Text(Home.routeName),
      Text(Home.routeName),
      Text(Home.routeName),
      Text(Home.routeName),
    ];

    return Scaffold(
      body: screens[currentIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex.value,
        onTap: (index) => currentIndex.value = index,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "Location",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "Scan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: "Trends",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.more_vert), label: "More"),
        ],
      ),
    );
  }
}
