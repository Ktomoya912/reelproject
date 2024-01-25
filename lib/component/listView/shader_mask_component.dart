import 'package:flutter/material.dart';

class ShaderMaskComponent extends StatelessWidget {
  const ShaderMaskComponent({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得
    return Container(
      color: Colors.white,
      height: mediaQueryData.size.height,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color.fromARGB(0, 255, 255, 255),
            ],
            stops: [
              0.95,
              1,
            ],
          ).createShader(bounds);
        },
        child: child,
      ),
    );
  }
}
