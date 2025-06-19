import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';

import '../../../../core/constants/images.dart';
import '../bloc/splash_bloc.dart'; 


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    context.read<SplashBloc>().add(const InitializeApp());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoaded) {
            
            Navigator.of(context).pushReplacementNamed(state.route);
          } else if (state is SplashError) {
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
            
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              SvgPicture.asset(
                AppImages.logo,
                width: context.width * 0.7, 
                height: context.width * 0.7,
              ),

              const SizedBox(height: 20),
              CircularProgressIndicator(
                color: Theme.of(context).primaryColor, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}