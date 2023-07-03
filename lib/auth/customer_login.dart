// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:as_shop/auth/forgot_password.dart';
import 'package:as_shop/data_models/cutomer_data_model.dart';
import 'package:as_shop/main_screens/customer_home.dart';
import 'package:as_shop/widgets/auth_widgets.dart';
import 'package:as_shop/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/google_sign_in_button.dart';

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
  bool processingGoogle = false; // Processing state for Google sign-in
  bool showResendButton = false;
  bool showResendTimer = false;
  Timer? resendTimer;
  int resendTimerSeconds = 0;
  int initialSeconds = 0; // Initial timer duration in seconds

/////////////////////////////////// Email Sign IN///////////////////////////
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
            // Check if the logged-in user is a customer
            final customerDoc = await FirebaseFirestore.instance
                .collection('customers')
                .doc(user.uid)
                .get();
            if (customerDoc.exists) {
              _formKey.currentState!.reset();
              _emailController.text = '';
              _passwordEController.text = '';
              Navigator.pushReplacementNamed(context, '/customer_home');
            } else {
              // If the user is not a customer, show an error message
              setState(() {
                processing = false;
              });
              FirebaseAuth.instance.signOut();

              MyMessageHandler.showSnackBar(
                _scaffoldKey,
                'You are not authorized as a customer',
              );
            }
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

/////////////////////////////// Sign In with Google ////////////////////////////
  Future<void> signInWithGoogle() async {
    try {
      setState(() {
        processingGoogle = true;
      });
      UserCredential userCredential;
      var _auth = FirebaseAuth.instance;
      GoogleSignIn _googleSignIn = GoogleSignIn();

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        // Now create the user credential and store into firebase console
        userCredential = await _auth.signInWithCredential(credential);
      }

      Customer userModel;
      // Check if the logged-in user is a customer
      final customerDoc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(userCredential.user!.uid)
          .get();
      if (customerDoc.exists) {
        // If the customer document exists, proceed with the login process

        _formKey.currentState!.reset();
        _emailController.text = '';
        _passwordEController.text = '';
        Navigator.pushReplacementNamed(context, '/customer_home');
      } else {
        // The customer document doesn't exist
        // Check if it's the user's first time signing in
        if (userCredential.additionalUserInfo!.isNewUser) {
          // Handle the first-time sign-in logic
          // You can navigate the user to a registration screen or any other relevant screen
          userModel = Customer(
            name: userCredential.user!.displayName ?? 'No Name',
            email: userCredential.user!.email ?? 'Email not Available',
            profileimage:
                userCredential.user!.photoURL ?? 'images/inapp/guest.jpg',
            phone: '',
            address: '',
            cid: userCredential.user!.uid,
          );
          await FirebaseFirestore.instance
              .collection('customers')
              .doc(userCredential.user!.uid)
              .set(userModel.toMap());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomerHomeScreen(),
            ),
          );
        } else {
          // Show a message that the user is not a customer and not an new user
          if (!kIsWeb) {
            await _googleSignIn.disconnect();
            await _googleSignIn.signOut();
          }
          await FirebaseAuth.instance.signOut();
          setState(() {
            processingGoogle = false;
          });
          MyMessageHandler.showSnackBar(
            _scaffoldKey,
            'You are not authorized as a customer',
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        processingGoogle = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
    } on PlatformException catch (e) {
      setState(() {
        processingGoogle = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
    } catch (e) {
      setState(() {
        processingGoogle = false;
      });
      MyMessageHandler.showSnackBar(
          _scaffoldKey, 'An error occurred while signing in with Google');
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
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
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
                          const SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: Divider(
                                    thickness: 1.5,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                                Text('  OR WITH  '),
                                SizedBox(
                                  width: 80,
                                  child: Divider(
                                    thickness: 1.5,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GoogleSignInButton(
                            onTap: () {
                              signInWithGoogle();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Loading indicator and black shade overlay
              if (processingGoogle)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
