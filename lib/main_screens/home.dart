import 'package:as_shop/categories/kids_categ.dart';
import 'package:as_shop/galleries/bags_gallery.dart';
import 'package:as_shop/galleries/beauty_gallery.dart';
import 'package:as_shop/galleries/electronics_gallery.dart';
import 'package:as_shop/galleries/homeandgarden_gallery.dart';
import 'package:as_shop/galleries/kids_gallery.dart';
import 'package:as_shop/galleries/men_gallery.dart';
import 'package:as_shop/galleries/women_gallery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../galleries/accessories_gallery.dart';
import '../galleries/shoes_gallery.dart';
import '../minor_screens/search.dart';
import '../widgets/fack_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100.withOpacity(0.5),
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: FakeSearch(),
            bottom: const TabBar(
                isScrollable: true,
                indicatorColor: Colors.yellow,
                indicatorWeight: 8,
                tabs: [
                  RepeatedTab(label: 'Mens'),
                  RepeatedTab(label: 'women'),
                  RepeatedTab(label: 'Shoes'),
                  RepeatedTab(label: 'Bags'),
                  RepeatedTab(label: 'Electronics'),
                  RepeatedTab(label: 'Accessories'),
                  RepeatedTab(label: 'Home & Garden'),
                  RepeatedTab(label: 'Kids'),
                  RepeatedTab(label: 'Beauty'),
                ])),
        body: const TabBarView(
          children: [
            MenGalleryScreen(),
            WomenGalleryScreen(),
            ShoesGalleryScreen(),
            BagsGalleryScreen(),
            ElectronicsGalleryScreen(),
            AccessoriesGalleryScreen(),
            HomeAndGardenGalleryScreen(),
            KidsGalleryScreen(),
            BeautyGalleryScreen(),
          ],
        ),
      ),
    );
  }
}
