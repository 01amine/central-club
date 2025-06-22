import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';
import 'package:soccer_complex/features/auth/presentation/widgets/text_field.dart';
import 'package:soccer_complex/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // email regex
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  // Validation function
  bool _validateForm() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    bool isValid = true;

    // Email validation
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = "L'email est requis";
      });
      isValid = false;
    } else if (!_isValidEmail(_emailController.text.trim())) {
      setState(() {
        _emailError = "Veuillez entrer un email valide";
      });
      isValid = false;
    }

    // Password validation
    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        _passwordError = "Le mot de passe est requis";
      });
      isValid = false;
    }

    return isValid;
  }

  void _handleLogin() {
    if (_validateForm()) {
      context.read<AuthBloc>().add(
            LoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                AppImages.auth_background,
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * 0.08),
                child: Column(
                  children: [
                    SizedBox(height: context.height * 0.1),
                    Image.asset(
                      AppImages.logo_png,
                      width: context.width * 0.2,
                      height: context.width * 0.2,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "CONNECTER VOUS",
                      style: AppTheme.darkTheme.textTheme.displaySmall,
                    ),
                    SizedBox(height: context.height * 0.05),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Votre email",
                            style: AppTheme.darkTheme.textTheme.titleMedium,
                          ),
                          SizedBox(height: context.height * 0.01),
                          MyTextField(
                            hintText: "Entrer votre email...",
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            errorText: _emailError,
                          ),
                          SizedBox(height: context.height * 0.03),
                          Text(
                            "Mot de passe",
                            style: AppTheme.darkTheme.textTheme.titleMedium,
                          ),
                          SizedBox(height: context.height * 0.01),
                          MyTextField(
                            hintText: "Entrer votre mot de passe...",
                            controller: _passwordController,
                            obscureText: true,
                            errorText: _passwordError,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.height * 0.04),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        Navigator.of(context).pushReplacementNamed('/home');
                        // if (state is AuthSuccess) {
                        //   Navigator.of(context).pushReplacementNamed('/home');
                        // } else if (state is AuthError) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(content: Text(state.message)),
                        //   );
                        // }
                      },
                      builder: (context, state) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: MaterialButton(
                            onPressed:
                                state is AuthLoading ? null : _handleLogin,
                            color: AppTheme.buttonColor,
                            minWidth: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: state is AuthLoading
                                ? const CircularProgressIndicator(
                                    color: AppTheme.primaryTextColor)
                                : Text(
                                    "CONTINUER",
                                    style: AppTheme
                                        .darkTheme.textTheme.labelLarge!
                                        .copyWith(
                                      color: AppTheme.primaryTextColor,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: context.height * 0.04),
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppTheme.borderColor)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.width * 0.03),
                          child: Text(
                            "OU",
                            style: AppTheme.darkTheme.textTheme.labelMedium,
                          ),
                        ),
                        Expanded(child: Divider(color: AppTheme.borderColor)),
                      ],
                    ),
                    SizedBox(height: context.height * 0.04),
                    MaterialButton(
                      onPressed: () {
                        // Handle Google Login (Backend initiated)
                      },
                      color: AppTheme.secondaryColor,
                      minWidth: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppTheme.borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppImages.google_icon,
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: context.width * 0.02),
                          Text(
                            "Continuer avec Google",
                            style: AppTheme.darkTheme.textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.height * 0.02),
                    MaterialButton(
                      onPressed: () {
                        // Handle Facebook Login (Backend initiated)
                      },
                      color: AppTheme.secondaryColor,
                      minWidth: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppTheme.borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppImages.facebook_icon,
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: context.width * 0.02),
                          Text(
                            "Continuer avec Facebook",
                            style: AppTheme.darkTheme.textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vous n'avez pas de compte ? ",
                          style: AppTheme.darkTheme.textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            "Créer un ici",
                            style: AppTheme.darkTheme.textTheme.bodyMedium!
                                .copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.height * 0.4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
