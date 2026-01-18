import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  Widget _getSeaech() {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.4),
            borderRadius: BorderRadius.circular(40 / 2),
          ),
          child: TextField(
            style: TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: '寻找你需要的商品',
              hintStyle: TextStyle(color: Colors.white, fontSize: 14),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  final List<String> imageUrls = [
    'https://picsum.photos/200/300?image=100',
    'https://picsum.photos/200/300?image=101',
    'https://picsum.photos/200/300?image=102',
  ];

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: imageUrls.map((url) {
            return Image.network(
              url,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width, // 设置图片宽度为屏幕宽度
            );
          }).toList(),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imageUrls.length, (index) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(index),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _currentIndex == index ? 40 : 30.0,
                  height: 6.0,
                  margin: EdgeInsets.only(right: 5, bottom: 10),
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.white : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            }),
          ),
        ),
        _getSeaech(),
      ],
    );
  }
}
