import 'package:flutter/material.dart';
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';
import 'package:soccer_complex/features/auth/presentation/widgets/text_field.dart';

import '../../../../core/theme/theme.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SizedBox(height: context.height * 0.04),
                  Image.asset(
                    AppImages.logo_png,
                    width: context.width * 0.2,
                    height: context.width * 0.2,
                    fit: BoxFit.contain,
                  ),

                  Text(
                    "CREER UN COMPTE",
                    style: AppTheme.darkTheme.textTheme.displaySmall,
                  ),
                  SizedBox(height: context.height * 0.04),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nom Complet",
                          style: AppTheme.darkTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: context.height * 0.01),
                        MyTextField(hintText: "Entrer votre nom complet..."),
                        SizedBox(height: context.height * 0.03),

                        // Date of Birth Field
                        Text(
                          "Date de naissance",
                          style: AppTheme.darkTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: context.height * 0.01),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            style: AppTheme.darkTheme.textTheme.bodyMedium,
                            readOnly: true,
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: AppTheme.darkTheme.copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: AppTheme.buttonColor,
                                        onPrimary: AppTheme.primaryTextColor,
                                        onSurface: AppTheme.primaryTextColor,
                                        surface: AppTheme.secondaryColor,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              AppTheme.primaryTextColor,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                            },
                            decoration: InputDecoration(
                              hintText: "JJ / MM / AAAA",
                              hintStyle:
                                  AppTheme.darkTheme.textTheme.labelMedium,
                              filled: true,
                              fillColor: AppTheme.accentColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: AppTheme
                                    .secondaryTextColor, // Calendar icon color
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                            ),
                          ),
                        ),
                        SizedBox(height: context.height * 0.03),

                        // Phone Number Field
                        Text(
                          "Numéro de téléphone",
                          style: AppTheme.darkTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: context.height * 0.01),
                        MyTextField(
                            hintText: "Entrer votre numéro de téléphone..."),
                        SizedBox(height: context.height * 0.03),

                        // Email Field
                        Text(
                          "Email",
                          style: AppTheme.darkTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: context.height * 0.01),
                        MyTextField(hintText: "Entrer votre email..."),
                        SizedBox(height: context.height * 0.03),

                        // Password Field
                        Text(
                          "Mot de passe",
                          style: AppTheme.darkTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: context.height * 0.01),
                        MyTextField(hintText: "Entrer votre mot de passe..."),
                      ],
                    ),
                  ),
                  SizedBox(height: context.height * 0.04),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      color: AppTheme.buttonColor,
                      minWidth: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "CREER COMPTE",
                        style:
                            AppTheme.darkTheme.textTheme.labelLarge!.copyWith(
                          color: AppTheme.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.height * 0.05),

                  // Already have an account text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Vous avez deja un compte ? ",
                        style: AppTheme.darkTheme.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          "Connectez ici",
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium!.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
