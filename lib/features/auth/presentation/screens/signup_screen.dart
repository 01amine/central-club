import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:soccer_complex/core/constants/images.dart';
import 'package:soccer_complex/core/extensions/extensions.dart';
import 'package:soccer_complex/features/auth/presentation/widgets/text_field.dart';

import '../../../../core/theme/theme.dart';
import '../bloc/auth_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;

  // Error messages
  String? _fullNameError;
  String? _birthdayError;
  String? _phoneNumberError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthdayController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Email validation function
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  // Phone number validation function
  bool _isValidPhoneNumber(String phone) {
    // Allow various phone number formats
    return RegExp(r'^[\+]?[0-9]{8,15}$').hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  // Password validation function
  bool _isValidPassword(String password) {
    // At least 6 characters
    return password.length >= 6;
  }

  // Validation function
  bool _validateForm() {
    setState(() {
      _fullNameError = null;
      _birthdayError = null;
      _phoneNumberError = null;
      _emailError = null;
      _passwordError = null;
    });

    bool isValid = true;

    // Full name validation
    if (_fullNameController.text.trim().isEmpty) {
      setState(() {
        _fullNameError = "Le nom complet est requis";
      });
      isValid = false;
    } else if (_fullNameController.text.trim().length < 2) {
      setState(() {
        _fullNameError = "Le nom doit contenir au moins 2 caractères";
      });
      isValid = false;
    }

    // Birthday validation
    if (_birthdayController.text.trim().isEmpty || _selectedDate == null) {
      setState(() {
        _birthdayError = "La date de naissance est requise";
      });
      isValid = false;
    } else {
      // Check if user is at least 13 years old
      DateTime now = DateTime.now();
      int age = now.year - _selectedDate!.year;
      if (now.month < _selectedDate!.month || 
          (now.month == _selectedDate!.month && now.day < _selectedDate!.day)) {
        age--;
      }
      if (age < 13) {
        setState(() {
          _birthdayError = "Vous devez avoir au moins 13 ans";
        });
        isValid = false;
      }
    }

    // Phone number validation
    if (_phoneNumberController.text.trim().isEmpty) {
      setState(() {
        _phoneNumberError = "Le numéro de téléphone est requis";
      });
      isValid = false;
    } else if (!_isValidPhoneNumber(_phoneNumberController.text.trim())) {
      setState(() {
        _phoneNumberError = "Veuillez entrer un numéro de téléphone valide";
      });
      isValid = false;
    }

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
    } else if (!_isValidPassword(_passwordController.text.trim())) {
      setState(() {
        _passwordError = "Le mot de passe doit contenir au moins 6 caractères";
      });
      isValid = false;
    }

    return isValid;
  }

  void _handleSignup() {
    if (_validateForm()) {
      context.read<AuthBloc>().add(
            SignupRequested(
              fullName: _fullNameController.text.trim(),
              birthday: _birthdayController.text.trim(),
              phoneNumber: _phoneNumberController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
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
                foregroundColor: AppTheme.primaryTextColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text = DateFormat('dd / MM / yyyy').format(picked);
        // Clear birthday error when date is selected
        _birthdayError = null;
      });
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
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nom Complet",
                            style: AppTheme.darkTheme.textTheme.titleMedium,
                          ),
                          SizedBox(height: context.height * 0.01),
                          MyTextField(
                            hintText: "Entrer votre nom complet...",
                            controller: _fullNameController,
                            keyboardType: TextInputType.name,
                            obscureText: false,
                            errorText: _fullNameError,
                          ),
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
                                color: _birthdayError != null ? Colors.red : Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                                  readOnly: true,
                                  controller: _birthdayController,
                                  onTap: () => _selectDate(context),
                                  decoration: InputDecoration(
                                    hintText: "JJ / MM / AAAA",
                                    hintStyle: AppTheme.darkTheme.textTheme.labelMedium,
                                    filled: true,
                                    fillColor: AppTheme.accentColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.calendar_today,
                                      color: AppTheme.secondaryTextColor,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                  ),
                                ),
                                if (_birthdayError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                                    child: Text(
                                      _birthdayError!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
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
                            hintText: "Entrer votre numéro de téléphone...",
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            obscureText: false,
                            errorText: _phoneNumberError,
                          ),
                          SizedBox(height: context.height * 0.03),

                          // Email Field
                          Text(
                            "Email",
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

                          // Password Field
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
                        if (state is AuthSuccess) {
                          Navigator.of(context).pushReplacementNamed('/home');
                        } else if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: MaterialButton(
                            onPressed: state is AuthLoading ? null : _handleSignup,
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
                                    "CREER COMPTE",
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
                            style: AppTheme.darkTheme.textTheme.bodyMedium!
                                .copyWith(
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
      ),
    );
  }
}