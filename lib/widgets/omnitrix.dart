import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';

class OmnitrixWidget extends StatelessWidget {
  final List<Widget> children;
  const OmnitrixWidget({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.8 -
          (context.themeData.appBarTheme.toolbarHeight ?? 0),
      child: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: LayoutBuilder(builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            double maxHeight = constraints.maxHeight;
            return Container(
                    width: maxWidth * 0.5,
                    height: maxHeight * 0.5,
                    padding: const EdgeInsets.only(bottom: 20, right: 20),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(188, 165, 255, 0),
                          Color(0xFF214d76)
                        ])),
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(120),
                      ),
                    ))
                // .container(
                //   width: maxWidth * 0.4,
                //   height: maxHeight * 0.35,
                //   decoration: const BoxDecoration(
                //     shape: BoxShape.circle,
                //     gradient: LinearGradient(
                //       colors: [
                //         Color(0xFFf4c4f3),
                //         Color(0xFFfc67fa),
                //       ],
                //     ),
                //   ),
                // )
                // .container(
                //   width: maxWidth * 0.8,
                //   height: maxHeight * 0.8,
                //   padding: const EdgeInsets.only(bottom: 40),
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.black.withOpacity(0.6),
                //   ),
                // )
                ;
          }),
        ),
      ),
    );
  }
}
