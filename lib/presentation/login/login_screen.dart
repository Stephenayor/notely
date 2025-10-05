import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notely/utils/error_dialog.dart';
import 'package:notely/utils/routes.dart';
import 'package:provider/provider.dart';
import '../../utils/app_loading_dialog.dart';
import 'login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // if(FirebaseAuth.instance.currentUser != null){
    //   context.go(Routes.home);
    // }
    final loginViewModel = context.read<LoginViewModel>();
    _emailController = TextEditingController(
      text: loginViewModel.savedEmail ?? "",
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loginViewModel = context.watch<LoginViewModel>();

    // Update controller when savedEmail is loaded
    if (_emailController.text.isEmpty && loginViewModel.savedEmail != null) {
      _emailController.text = loginViewModel.savedEmail!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Image.asset(
                      'assets/images/writing.png',
                      height: 80,
                      width: 90,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Reconnect with your notes & continue your story.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 40),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    // Consumer<LoginViewModel>(
                    //   builder: (context, homeViewModel, _) {
                    //     return TextFormField(
                    //       controller: _emailController,
                    //       decoration: const InputDecoration(
                    //         prefixIcon: Icon(Icons.email_outlined),
                    //         hintText: 'Email',
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.all(Radius.circular(30)),
                    //         ),
                    //       ),
                    //       validator: (value) {
                    //         if (value == null || value.isEmpty) {
                    //           return 'Please enter your email';
                    //         }
                    //         if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    //           return 'Enter a valid email';
                    //         }
                    //         return null;
                    //       },
                    //       onChanged: (value) => homeViewModel.savedEmail = value,
                    //     );
                    //   },
                    // ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Forgot your password?"),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF836FFF)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed:
                              loginViewModel.isLoading
                                  ? null
                                  : () async {
                                    if (_formKey.currentState!.validate()) {
                                      AppLoadingDialog.show(
                                        context,
                                        "Logging in....",
                                      );
                                      final user = await loginViewModel
                                          .loginWithEmail(
                                            _emailController.text,
                                            _passwordController.text,
                                          );
                                      if (user != null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Login Successful!'),
                                          ),
                                        );
                                        context.go(Routes.home);
                                        AppLoadingDialog.hide(context);
                                      } else if (loginViewModel.errorMessage !=
                                          null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              loginViewModel.errorMessage!,
                                            ),
                                          ),
                                        );
                                        AppLoadingDialog.hide(context);
                                        ErrorDialog.show(
                                          context,
                                          "Login Failed",
                                          loginViewModel.errorMessage!,
                                        );
                                      } else {
                                        print(loginViewModel.errorMessage);
                                        ErrorDialog.show(
                                          context,
                                          "Login Failed",
                                          loginViewModel.errorMessage!,
                                        );
                                      }
                                    }
                                  },
                          child:
                          // loginViewModel.isLoading
                          //     ? const CircularProgressIndicator(
                          //       color: Colors.white,
                          //     )
                          //     : const Text("Login"),
                          const Text('Login'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        const Text(
                          "Continue with",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/google.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                                onPressed: () async {
                                  AppLoadingDialog.show(
                                    context,
                                    "Logging in....",
                                  );
                                  final user =
                                      await loginViewModel.signInWithGoogle();
                                  if (user != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Google Sign-in Successful!',
                                        ),
                                      ),
                                    );
                                    context.push(Routes.home);
                                    AppLoadingDialog.hide(context);
                                  }
                                },
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/facebook.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/apple.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account yet? "),
                        GestureDetector(
                          onTap: () {
                            context.go(Routes.signUp);
                          },
                          child: const Text(
                            "Signup",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
