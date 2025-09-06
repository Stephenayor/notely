import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notely/presentation/onboarding/sign_up_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import '../../data/model/user_profile.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/success_screen.dart';
import 'google_auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool agreedToTerms = false;
  final GoogleAuthService _authService = GoogleAuthService();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SignUpViewmodel>();
    final theme = Theme.of(context);
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            onChanged: () => setState(() {}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 45),

                // Email
                _buildInputField(
                  controller: _emailController,
                  hint: 'Enter your Email here',
                  icon: Icons.email_outlined,
                  validator: (value) {
                    final email = value ?? '';
                    final isValidEmail = RegExp(
                      r'^[^@]+@[^@]+\.[^@]+',
                    ).hasMatch(email);
                    if (!isValidEmail) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 22),

                // Full name
                _buildInputField(
                  controller: _fullNameController,
                  hint: 'Full Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    return (value == null || value.trim().isEmpty)
                        ? 'Name is required'
                        : null;
                  },
                ),
                const SizedBox(height: 22),

                // Password
                _buildInputField(
                  controller: _passwordController,
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    if (!RegExp(r'\d').hasMatch(value)) {
                      return 'Password must contain at least one digit';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Terms checkbox
                Row(
                  children: [
                    Checkbox(
                      value: agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          agreedToTerms = value ?? false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'I Have Read And Agree To ',
                          children: [
                            TextSpan(
                              text: 'User Agreement',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        (_formKey.currentState?.validate() == true &&
                                agreedToTerms)
                            ? () async {
                              FocusScope.of(context).unfocus();
                              final name = _fullNameController.text.trim();
                              final email = _emailController.text.trim();
                              final password = _passwordController.text;

                              final user = await viewModel.signUpWithEmail(
                                name,
                                email,
                                password,
                              );

                              if (user != null) {
                                if (context.mounted) {
                                  context.go(
                                    Routes.successScreen,
                                    extra: {
                                      "title": "Account Created Successfully",
                                      "message":
                                          "Welcome aboard! Your account has been created.",
                                      "primaryButtonText": "Go to Login",
                                      "secondaryButtonText": "Done",
                                      "primaryRoute": Routes.login,
                                      "secondaryRoute": Routes.signUp,
                                    },
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (_) => AlertDialog(
                                          title: const Text('Sign Up Failed'),
                                          content: Text(
                                            viewModel.errorMessage ??
                                                'Unknown error',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                  );
                                }
                              }
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // OR
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),

                // Social Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(
                      "assets/images/apple.png",
                      onTap:
                          agreedToTerms
                              ? () {
                                // Handle Apple sign-in
                              }
                              : () => showToast(),
                    ),
                    const SizedBox(width: 20),
                    _buildSocialIcon(
                      "assets/images/google.png",
                      onTap:
                          agreedToTerms
                              ? () async {
                                //Handle Click
                                User? user =
                                    await _authService.signInWithGoogle();
                                if (user != null) {
                                  final profile = UserProfile(
                                    id: const Uuid().v4(),
                                    email: user.email ?? "",
                                    name: user.displayName ?? "",
                                    password:
                                        "", // Google sign-in doesn't provide password
                                    joinDate: DateTime.now(),
                                  );

                                  await viewModel.saveUserProfile(
                                    user,
                                    profile,
                                  );
                                  Constants.showToast(
                                    "Profile saved!",
                                    Toast.lengthShort,
                                  );
                                  if (context.mounted) {
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder:
                                    //         (_) => SuccessScreen(
                                    //           title:
                                    //               "Account Created Successfully",
                                    //           message:
                                    //               "${user.displayName} you have successfully created your notely account",
                                    //           primaryButtonText: "Go Home",
                                    //           secondaryButtonText: "Done",
                                    //           onPrimaryPressed: () {
                                    //             context.go(
                                    //               Routes.home,
                                    //             ); // Navigate to Home
                                    //           },
                                    //           onSecondaryPressed: () {
                                    //             context.pop(
                                    //               context,
                                    //             ); // Close success screen
                                    //           },
                                    //         ),
                                    //   ),
                                    // );
                                  }

                                  //Navigate to home
                                  // context.go(Routes.home);
                                } else {
                                  // Sign-in failed
                                  Constants.showToast(
                                    "Failed Sign up",
                                    Toast.lengthShort,
                                  );
                                }
                              }
                              : () => showToast(),
                    ),
                  ],
                ),
                const Spacer(),

                // Sign In text
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Joined us before? ",
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 65),
                if (viewModel.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    TextEditingController? controller,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }

  Widget _buildSocialIcon(String assetPath, {required VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.4 : 1.0,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[100],
          child: Image.asset(
            assetPath,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  showToast() {
    Constants.showToast(
      "Please accept the terms and conditions first!",
      Toast.lengthShort,
    );
  }
}
