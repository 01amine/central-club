import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soccer_complex/core/constants/images.dart';
import '../cubit/bottom_navigation_cubit.dart';

class HomeLayout extends StatelessWidget {
  final List<Widget> _pages = [
    Scaffold(
      body: Center(
        child: Text("home screen"),
      ),
    ),
    Scaffold(
      body: Center(
        child: Text("settings screen"),
      ),
    ),
    Scaffold(
      body: Center(
        child: Text("history screen"),
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
      bottomNavigationBar: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state,
            onTap: (index) {
              context.read<BottomNavigationCubit>().changeTab(index);
            },
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.hisoty_icon,
                  color: state == 0 ? Colors.black : Colors.grey,
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.home_icon,
                  color: state == 1 ? Colors.black : Colors.grey,
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.settings_icon,
                  color: state == 2 ? Colors.black : Colors.grey,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
