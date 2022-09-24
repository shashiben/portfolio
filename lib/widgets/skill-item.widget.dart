import 'package:flutter_next/flutter_next.dart';
import 'package:flutter/material.dart';

import '../core/models/feature-item.model.dart';

class FeatureItem extends StatefulWidget {
  final FeatureModel feature;
  const FeatureItem({Key? key, required this.feature}) : super(key: key);

  @override
  State<FeatureItem> createState() => _FeatureItemState();
}

class _FeatureItemState extends State<FeatureItem>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.black),
      child: HoverWidget(
          hoverDuration: Duration.zero,
          builder: (BuildContext context, bool isHovered) {
            if (isHovered) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
            return ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.08).animate(_controller),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isHovered ? context.primaryColor : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(18, 66, 101, 0.08),
                      blurRadius: 15,
                      spreadRadius: isHovered ? 10 : 5,
                      offset: Offset(
                        2.0,
                        isHovered ? 6.0 : 2.0,
                      ),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Icon(
                    widget.feature.icon,
                    size: 36,
                    color: isHovered ? Colors.white : context.primaryColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.feature.title,
                    style: TextStyle(
                      color: !isHovered ? context.primaryColor : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.feature.description,
                    style: TextStyle(
                      color: !isHovered ? context.primaryColor : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                ]),
              ),
            );
          }),
    );
  }
}
