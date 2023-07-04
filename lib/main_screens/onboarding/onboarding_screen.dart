import 'dart:async';

import 'package:as_shop/main_screens/onboarding/widgets/background_imgae.dart';
import 'package:as_shop/minor_screens/subcatag_products.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../galleries/shoes_gallery.dart';
import '../../pallet/colors.dart';
import 'widgets/build_caurasour_images.dart';
import 'widgets/divider.dart';
import 'widgets/star_clipper.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  Timer? countDownTimer;
  int autoSkipTime = 10;

  List<Map<String, dynamic>> get onBoardingSliderData {
    return [
      {
        'imageUrl': 'images/onboarding/watches.JPEG',
        'onTap': () {
          // Callback for the watches poster
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const SubCategProducts(
                  subcatagName: 'smart watch',
                  maincatagName: 'electronics',
                  fromOnBoarding: true,
                ),
              ),
              (route) => false);
        },
      },
      {
        'imageUrl': 'images/onboarding/shoes.JPEG',
        'onTap': () {
          // Callback for the shoes poster
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ShoesGalleryScreen(
                  fromOnBoarding: true,
                )
              ),
              (route) => false);
        },
      },
      {
        'imageUrl': 'images/onboarding/sale.JPEG',
        'onTap': () {
          // Callback for the sale poster
          print('Tapped on third slider item');
        },
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    countDownTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        autoSkipTime--;
      });
      if (autoSkipTime <= 0) {
        timer.cancel();
        navigateToHome();
      }
    });
  }

  void navigateToHome() {
    Navigator.pushReplacementNamed(context, '/customer_home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackGroundImage(
            image: 'images/onboarding/background.jpg',
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0).copyWith(left: 24),
                child: InkWell(
                  onTap: navigateToHome,
                  child: Container(
                    height: 34,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: const Color.fromARGB(83, 159, 159, 159),
                    ),
                    child: Center(
                      child: autoSkipTime <= 0
                          ? const Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Skip | $autoSkipTime',
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              CarouselSlider.builder(
                itemCount: onBoardingSliderData.length,
                itemBuilder: (context, index, realIndex) {
                  final data = onBoardingSliderData[index];

                  return BuildImages(
                    imageUrl: data['imageUrl'],
                    index: index,
                    onTap: data['onTap'],
                  );
                },
                options: CarouselOptions(
                  height: 370,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  pageSnapping: false,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.70,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flash Deal',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 38,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Up to 90% off on all products just for you',
                      style: GoogleFonts.abel(
                        color: const Color.fromARGB(210, 181, 181, 148),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GradientDivider(),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Check Out',
                          style: GoogleFonts.quicksand(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 34,
                        ),
                        InkWell(
                          onTap: navigateToHome,
                          child: SizedBox(
                            height: 70,
                            width: 70,
                            child: ClipPath(
                              clipper: StarClipper(16),
                              child: Container(
                                height: 150,
                                color: Pallet.boarderColor,
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_forward_outlined,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
