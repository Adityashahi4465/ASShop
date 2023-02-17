// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:as_shop/main_screens/supplier_home.dart';
import 'package:as_shop/widgets/yellow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const textColors = [
  Colors.yellowAccent,
  Colors.red,
  Colors.blueAccent,
  Colors.green,
  Colors.purple,
  Colors.teal,
];
var textStyle = GoogleFonts.acme(
  fontWeight: FontWeight.bold,
  fontSize: 45,
);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool processing = false;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  late String _uid;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/inapp/bgimage.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: Flexible(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'WELCOME',
                      textStyle: textStyle,
                      colors: textColors,
                    ),
                    ColorizeAnimatedText('ASStore',
                        textStyle: textStyle, colors: textColors),
                  ],
                  repeatForever: true,
                  isRepeatingAnimation: true,
                ),
                const SizedBox(
                  height: 120,
                  child: Image(
                    image: AssetImage('images/inapp/logo.jpg'),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: DefaultTextStyle(
                    style: GoogleFonts.acme(
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                      fontSize: 45,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        RotateAnimatedText('BUY'),
                        RotateAnimatedText('SELL'),
                        RotateAnimatedText('ASShop'),
                      ],
                      repeatForever: true,
                    ),
                  ),
                ),
                // const Text(
                //   'SHOP',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 30,
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Suppliers only',
                              style: TextStyle(
                                  color: Colors.yellowAccent,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: const BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnimatedLogo(controller: _controller),
                              YellowButton(
                                label: 'log In',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/supplier_login');
                                },
                                width: 0.25,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: YellowButton(
                                  label: 'Sign Up',
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/supplier_signup');
                                  },
                                  width: 0.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: YellowButton(
                                label: 'log In',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/customer_login');
                                },
                                width: 0.25,
                              ),
                            ),
                            YellowButton(
                              label: 'Sign Up',
                              width: 0.25,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/customer_signup',
                                );
                              },
                            ),
                            AnimatedLogo(controller: _controller),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white38.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GoogleFacebookLogIn(
                          label: 'Google',
                          onPressed: () {},
                          child: const Image(
                            image: AssetImage('images/inapp/google.jpg'),
                          ),
                        ),
                        GoogleFacebookLogIn(
                          label: 'Facebook',
                          onPressed: () {},
                          child: const Image(
                            image: AssetImage('images/inapp/facebook.jpg'),
                          ),
                        ),
                        processing == true
                            ? const CircularProgressIndicator()
                            : GoogleFacebookLogIn(
                                label: 'Guest',
                                onPressed: () async {
                                  setState(() {
                                    processing = true;
                                  });
                                  await FirebaseAuth.instance
                                      .signInAnonymously()
                                      .whenComplete(() async {
                                    _uid =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    await customers.doc(_uid).set({
                                      'name': 'Guest',
                                      'email': '',
                                      'profileimage': '',
                                      'phone': '',
                                      'address': '',
                                      'cid': _uid,
                                    });
                                  });

                                  Navigator.pushReplacementNamed(
                                      context, '/customer_home');
                                },
                                child: const Icon(
                                  Icons.person,
                                  size: 55,
                                  color: Colors.lightBlueAccent,
                                )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    super.key,
    required AnimationController controller,
  }) : _controller = controller;

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
      child: const Image(
        image: AssetImage('images/inapp/logo.jpg'),
      ),
    );
  }
}

class GoogleFacebookLogIn extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Widget child;
  const GoogleFacebookLogIn({
    required this.label,
    required this.onPressed,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            SizedBox(height: 45, width: 45, child: child),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
