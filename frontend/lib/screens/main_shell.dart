// lib/screens/main_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home/home_screen.dart';
import 'confizone/confizone_screen.dart';
import 'circle/circle_screen.dart';
import 'me/me_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Main application shell with 4 primary tabs:
/// 1. Home - Discover what matters to me
/// 2. ConfiZone ([[ACTION_HUB_NAME]]) - Choose what to do (Includes Resources per OD-01)
/// 3. Circle ([[COMMUNITY_TAB_NAME]]) - Connect and participate
/// 4. Me - Personal growth record, scores, and settings
///
/// NOTE (OD-01): The Resources tab has been integrated directly into ConfiZone
/// as a dedicated library sub-section in accordance with the 4-tab product specification.
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
    CircleScreen(),
    MeScreen(),
  ];

  static const List<Map<String, dynamic>> _navItems = [
    {
      'label': 'Home',
      'icon': Icons.home_outlined,
      'activeIcon': Icons.home_rounded,
      'hasBadge': false,
    },
    {
      'label': 'ConfiZone',
      'icon': Icons.explore_outlined,
      'activeIcon': Icons.explore_rounded,
      'hasBadge': false,
    },
    {
      'label': 'Circle',
      'icon': Icons.groups_outlined,
      'activeIcon': Icons.groups_rounded,
      'hasBadge': true, // Community notification indicator
    },
    {
      'label': 'Me',
      'icon': Icons.person_outline_rounded,
      'activeIcon': Icons.person_rounded,
      'hasBadge': false,
    },
  ];

  void _onTabSelected(int index) {
    if (_selectedIndex != index) {
      HapticFeedback.selectionClick();
      setState(() => _selectedIndex = index);
    }
  }

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
          border: const Border(
            top: BorderSide(color: AppColors.lightGrey, width: 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final isActive = i == _selectedIndex;
                final bool hasBadge = (item['hasBadge'] as bool? ?? false) && !isActive;

                return Expanded(
                  child: InkWell(
                    onTap: () => _onTabSelected(i),
                    splashColor: AppColors.coral.withOpacity(0.08),
                    highlightColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated top active bar
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          height: 3,
                          width: isActive ? 24 : 0,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: AppColors.coral,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        // Icon with badge
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedScale(
                              scale: isActive ? 1.08 : 1.0,
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOutBack,
                              child: Icon(
                                isActive
                                    ? item['activeIcon'] as IconData
                                    : item['icon'] as IconData,
                                color: isActive ? AppColors.coral : AppColors.darkGrey,
                                size: 24,
                              ),
                            ),
                            if (hasBadge)
                              Positioned(
                                top: -2,
                                right: -4,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.coral,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 3),

                        // Label (animated text color & weight)
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 180),
                          style: AppTypography.montserrat(
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive ? AppColors.coral : AppColors.darkGrey,
                          ),
                          child: Text(item['label'] as String),
                        ),
                      ],
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
