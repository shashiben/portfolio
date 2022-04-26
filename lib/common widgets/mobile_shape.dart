import 'package:flutter/material.dart';

class MobilePhone extends StatelessWidget {
  final double? width, height;
  final Widget? child;

  final Size? volumeButton, powerButton;
  final double mobileBorderWidth, mobileBorderRadius;
  final ButtonPosition volumeUp, volumneDown, powerBtn;
  const MobilePhone({
    Key? key,
    this.width,
    this.child,
    this.height,
    this.mobileBorderRadius = 20.0,
    this.mobileBorderWidth = 6.0,
    this.volumeButton,
    this.powerButton,
    this.volumeUp = (const ButtonPosition(top: 45, left: 0)),
    this.volumneDown = (const ButtonPosition(top: 85, left: 0)),
    this.powerBtn = (const ButtonPosition(top: 60, right: 0)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mobileWidth = width ?? 200;
    double mobileHeight = height ?? 400;
    Size volumeBtnSize = volumeButton ?? const Size(5, 35);
    Size powerBtnSize = powerButton ?? const Size(5, 35);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      height: mobileHeight,
      width: mobileWidth + 5,
      child: Stack(
        children: [
          Center(
            child: Container(
              child: child,
              height: mobileHeight,
              width: mobileWidth,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: mobileBorderWidth),
                  borderRadius: BorderRadius.circular(mobileBorderRadius)),
            ),
          ),
          Positioned(
              right: volumeUp.right,
              bottom: volumeUp.bottom,
              left: volumeUp.left,
              top: volumeUp.top,
              child: Container(
                width: volumeBtnSize.width,
                height: volumeBtnSize.height,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
              )),
          Positioned(
              right: volumneDown.right,
              bottom: volumneDown.bottom,
              left: volumneDown.left,
              top: volumneDown.top,
              child: Container(
                width: volumeBtnSize.width,
                height: volumeBtnSize.height,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
              )),
          Positioned(
              right: powerBtn.right,
              bottom: powerBtn.bottom,
              left: powerBtn.left,
              top: powerBtn.top,
              child: Container(
                width: powerBtnSize.width,
                height: powerBtnSize.height,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20))),
              )),
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  child: Center(
                      child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        gradient: RadialGradient(colors: [
                          Colors.black87,
                          Colors.black,
                          Colors.grey,
                          Colors.white
                        ]),
                        shape: BoxShape.circle,
                        color: Colors.grey),
                  )),
                  width: 100,
                  height: 15,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                ),
              ))
        ],
      ),
    );
  }
}

class ButtonPosition {
  final double? top, bottom, right, left;

  const ButtonPosition({
    this.top,
    this.bottom,
    this.right,
    this.left,
  });
}
