import 'package:as_shop/widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';

class FullScreenView extends StatefulWidget {
  final List<dynamic> imagesList;
  const FullScreenView({required this.imagesList, super.key});

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              '1/5',
              style: TextStyle(
                fontSize: 24,
                letterSpacing: 1.8,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.5,
            child: PageView(
              children: List.generate(
                widget.imagesList.length,
                (index) {
                  return InteractiveViewer(
                    transformationController: TransformationController(),
                    child: Image.network(
                      widget.imagesList[index].toString(),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: height * 0.2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imagesList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  width: 120,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Colors.yellow,
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.imagesList[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
