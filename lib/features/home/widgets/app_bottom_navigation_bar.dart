import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miiincare/core/constants/app_color.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  /// Space scrollable content needs at the bottom to clear the floating bar.
  static const double contentClearance = 96;

  @override
  Widget build(BuildContext context) => SafeArea(
    minimum: const EdgeInsets.fromLTRB(28, 0, 28, 12),
    child: Container(
      height: 62,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 14,
            spreadRadius: -5,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.68),
            blurRadius: 10,
            spreadRadius: -3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.34),
                  Colors.white.withValues(alpha: 0.16),
                ],
              ),
              borderRadius: BorderRadius.circular(34),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.58),
                width: 1.1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: List.generate(_items.length, (index) {
                  final item = _items[index];
                  final selected = index == selectedIndex;
                  return Expanded(
                    child: Semantics(
                      selected: selected,
                      label: item.label,
                      button: true,
                      child: Tooltip(
                        message: item.label,
                        child: InkWell(
                          onTap: () => onDestinationSelected(index),
                          borderRadius: BorderRadius.circular(28),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: selected
                                  ? LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.32),
                                        AppColor.ink.withValues(alpha: 0.10),
                                      ],
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(28),
                              border: selected
                                  ? Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.32,
                                      ),
                                    )
                                  : null,
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.07,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 5),
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: Icon(
                                selected ? item.selectedIcon : item.icon,
                                key: ValueKey('$index-$selected'),
                                size: 26,
                                color: selected
                                    ? AppColor.primary
                                    : AppColor.ink,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _NavigationItem {
  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const _items = [
  _NavigationItem(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  _NavigationItem(
    label: 'Shop',
    icon: Icons.storefront_outlined,
    selectedIcon: Icons.storefront_rounded,
  ),
  _NavigationItem(
    label: 'Categories',
    icon: Icons.grid_view_rounded,
    selectedIcon: Icons.grid_view_rounded,
  ),
  _NavigationItem(
    label: 'Bag',
    icon: Icons.shopping_bag_outlined,
    selectedIcon: Icons.shopping_bag_rounded,
  ),
  _NavigationItem(
    label: 'Account',
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
  ),
];
