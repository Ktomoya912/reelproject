import 'package:flutter/material.dart';
import 'dart:async';

class Carousel extends StatefulWidget {
  const Carousel({
    Key? key,
    required this.pages,
    required this.timeJedge,
  }) : super(key: key);
  final List<Widget> pages;
  final bool timeJedge;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  void initState() {
    // ④
    super.initState();

    Timer.periodic(const Duration(seconds: 7), (Timer timer) {
      if (_currentPage < widget.pages.length - 1 && widget.timeJedge) {
        // ⑤
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        _pageController.jumpToPage(0); // ⑥
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.pages;
    final pageLength = pages.length;
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (value) {
            // ページが切り替わったときにそのindexがvalueに入ってくる。
            // 現在表示中のページが何番目か知りたいのでcurrentIndexにvalueを渡す。
            setState(() {
              _currentPage = value;
            });
          },
          children: widget.pages,
        ),
        Align(
          alignment: const Alignment(0, .95),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pageLength,
              (index) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  width: index == _currentPage ? 9 : 6,
                  height: index == _currentPage ? 9 : 6,
                  decoration: BoxDecoration(
                    color: index == _currentPage
                        ? Colors.white
                        : Colors.grey.withOpacity(
                            0.6,
                          ),
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
