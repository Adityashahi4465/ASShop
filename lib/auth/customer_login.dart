// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:as_shop/auth/forgot_password.dart';
import 'package:as_shop/widgets/auth_widgets.dart';
import 'package:as_shop/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({Key? key}) : super(key: key);

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordEController = TextEditingController();
  bool passwordVisible = true;
  bool processing = false;
  bool showResendButton = false;
  bool showResendTimer = false;
  Timer? resendTimer;
  int resendTimerSeconds = 0;
  int initialSeconds = 0; // Initial timer duration in seconds

  void signIn() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        final email = _emailController.text.trim();
        final password = _passwordEController.text;

        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = userCredential.user;
        if (user != null) {
          await user.reload();
          if (user.emailVerified) {
            _formKey.currentState!.reset();
            _emailController.text = '';
            _passwordEController.text = '';
            Navigator.pushReplacementNamed(context, '/customer_home');
          } else {
            setState(() {
              processing = false;
            });
            MyMessageHandler.showSnackBar(
              _scaffoldKey,
              'Please check your email for verification',
            );
            setState(() {
              showResendButton = true;
            });
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          processing = false;
        });

        MyMessageHandler.showSnackBar(
          _scaffoldKey,
          e.message.toString(),
        );
      } catch (e) {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(
          _scaffoldKey,
          'An error occurred while logging in!',
        );
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(
        _scaffoldKey,
        'Please fill in all fields',
      );
    }
  }

  void startResendTimer() {
    resendTimerSeconds = initialSeconds + 30;

    resendTimer?.cancel(); // Cancel any existing timer

    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        resendTimerSeconds--;

        if (resendTimerSeconds <= 0) {
          timer.cancel();
          showResendTimer = false;
          showResendButton = true;
        }
      });
    });
  }

  Future<void> reSendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        setState(() {
          showResendTimer = true;
          showResendButton = false;
        });
        startResendTimer();
      }
    } catch (e) {
      setState(() {
        showResendButton = true;
      });
      MyMessageHandler.showSnackBar(
        _scaffoldKey,
        'Failed to send verification email',
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordEController.dispose();
    resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeaderLabel(
                        headerLabel: 'Log In',
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email';
                            } else if (value.isValidEmail() == false) {
                              return 'invalid email';
                            } else if (value.isValidEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Email Address',
                            hintText: 'Enter your Email',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: _passwordEController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                            return null;
                          },
                          obscureText: passwordVisible,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Password',
                            hintText: 'Enter your Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        ),
                        child: const Text(
                          'Forget Password',
                          style: TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      ),
                      HaveAccount(
                        haveAccount: 'Don\'t Have Account? ',
                        actionLabel: 'Sign Up',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/customer_signup');
                        },
                      ),
                      processing == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.purple,
                              ),
                            )
                          : AuthMainButton(
                              mainButtonLabel: 'Log In',
                              onPressed: () {
                                signIn();
                              },
                            ),
                      if (showResendButton)
                        TextButton(
                          onPressed: reSendEmailVerification,
                          child: const Center(
                            child: Text(
                              'Resend Verification Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                      if (showResendTimer)
                        Center(
                          child: Text(
                            'Resend Email in ${resendTimerSeconds}s',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
