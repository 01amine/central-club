import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/features/history/presentation/pages/history_screen.dart';
import 'package:soccer_complex/features/home/presentation/screens/reserving_screen.dart';
import '../cubit/bottom_navigation_cubit.dart';

class HomeLayout extends StatelessWidget {
  final List<Widget> _pages = [
    HistoryScreen(),
    ReservingScreen(),
    Scaffold(
      body: Center(
        child: Text("settings screen"),
      ),
    ),
  ];

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, state) {
          return _pages[state];
        },
      ),
      extendBody: true,
      bottomNavigationBar: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 25,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              color: Colors.black87,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      context,
                      index: 0,
                      currentIndex: state,
                      iconPath: AppImages.hisoty_icon,
                      label: 'history',
                    ),
                    _buildNavItem(
                      context,
                      index: 1,
                      currentIndex: state,
                      iconPath: AppImages.home_icon,
                      label: 'home',
                    ),
                    _buildNavItem(
                      context,
                      index: 2,
                      currentIndex: state,
                      iconPath: AppImages.settings_icon,
                      label: 'settings',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required int currentIndex,
    required String iconPath,
    required String label,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<BottomNavigationCubit>().changeTab(index);
        },
        child: SizedBox(
          height: 70,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 0.4,
                ),
                color: isSelected
                    ? Colors.grey.withOpacity(0.3)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 28,
                height: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
