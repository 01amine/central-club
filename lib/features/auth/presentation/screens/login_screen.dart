import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';
import 'package:soccer_complex/features/auth/presentation/widgets/text_field.dart';

import '../../../../core/theme/theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Votre email",
                          style: AppTheme.darkTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: context.height * 0.01),
                        MyTextField(hintText: "Entrer votre email..."),
                        SizedBox(height: context.height * 0.03),
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
                      color: AppTheme.buttonColor, // Using theme's buttonColor
                      minWidth: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "CONTINUER",
                        style:
                            AppTheme.darkTheme.textTheme.labelLarge!.copyWith(
                          color: AppTheme.primaryTextColor, // Button text color
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.height * 0.04),
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                              color: AppTheme
                                  .borderColor)), // Using theme's borderColor
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
                      Navigator.pushNamed(context, '/home');
                    },
                    color: AppTheme.secondaryColor,
                    minWidth: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
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
                          style: AppTheme.darkTheme.textTheme
                              .labelLarge, // Using theme's labelLarge
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.height * 0.02),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    color: AppTheme
                        .secondaryColor, // Using secondaryColor for social buttons background
                    minWidth: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          color: AppTheme
                              .borderColor), // Border for social buttons
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
                          style: AppTheme.darkTheme.textTheme
                              .labelLarge, // Using theme's labelLarge
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
                        style: AppTheme.darkTheme.textTheme
                            .bodyMedium, // Using theme's bodyMedium
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          "Créer un ici",
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium!.copyWith(
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
    );
  }
}
