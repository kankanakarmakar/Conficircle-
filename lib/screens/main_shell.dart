// lib/screens/main_shell.dart
import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'confizone/confizone_screen.dart';
import 'resources/resources_screen.dart';
import 'circle/circle_screen.dart';
import 'me/me_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  static const List<Widget> _screens = [
    HomeScreen(),
    ConfiZoneScreen(),
    ResourcesScreen(),
    CircleScreen(),
    MeScreen(),
  ];

  static const List<Map<String, dynamic>> _navItems = [
    {'label': 'Home', 'icon': Icons.home_outlined, 'activeIcon': Icons.home_rounded},
    {'label': 'ConfiZone', 'icon': Icons.explore_outlined, 'activeIcon': Icons.explore_rounded},
    {'label': 'Resources', 'icon': Icons.menu_book_outlined, 'activeIcon': Icons.menu_book_rounded},
    {'label': 'Circle', 'icon': Icons.group_outlined, 'activeIcon': Icons.group_rounded},
    {'label': 'Me', 'icon': Icons.person_outline_rounded, 'activeIcon': Icons.person_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final isActive = i == _selectedIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Active indicator dot
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 3,
                            width: isActive ? 24 : 0,
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: AppColors.coral,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Icon(
                            isActive ? item['activeIcon'] as IconData : item['icon'] as IconData,
                            color: isActive ? AppColors.coral : AppColors.darkGrey,
                            size: 22,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item['label'] as String,
                            style: AppTypography.montserrat(
                              fontSize: 10,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                              color: isActive ? AppColors.coral : AppColors.darkGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
