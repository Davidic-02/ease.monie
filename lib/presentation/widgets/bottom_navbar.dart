import 'package:esae_monie/presentation/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svgs/home.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                currentIndex.value == 0 ? Colors.blue : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svgs/location.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                currentIndex.value == 1 ? Colors.blue : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: "Location",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svgs/scanner.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                currentIndex.value == 2 ? Colors.blue : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: "Scan",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svgs/upward_Stat.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                currentIndex.value == 3 ? Colors.blue : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: "Trends",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svgs/category.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                currentIndex.value == 4 ? Colors.blue : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: "Categories",
          ),
        ],
      ),
    );
  }
}
