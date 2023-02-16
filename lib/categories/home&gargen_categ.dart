import 'package:flutter/material.dart';
import '../utilities/categ_list.dart';

import '../minor_screens/subcatag_products.dart';
import '../widgets/categ_widgets.dart';

class HomeGardenCategory extends StatelessWidget {
  const HomeGardenCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CategHeaderLabel(
                    HeaderLabel: 'Home & Garden',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.64,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      children:
                          List.generate(homeandgarden.length - 1, (index) {
                        return SubCategModel(
                          mainCategName: 'homeandgarden',
                          subCategName: homeandgarden[index + 1],
                          assetName: 'images/homegarden/home$index.jpg',
                          subCategLabel: homeandgarden[index + 1],
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: SliderBar(
              maincategName: 'homegarden',
            ),
          )
        ],
      ),
    );
  }
}
