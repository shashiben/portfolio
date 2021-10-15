import 'package:flutter/material.dart';

class LocationDateWidget extends StatelessWidget {
  const LocationDateWidget({
    Key? key,
    required this.duration,
    this.durationTextStyle,
    required this.location,
    this.locationTextStyle,
    this.locationIcon,
    this.durationIcon,
  }) : super(key: key);

  final String duration;
  final TextStyle? durationTextStyle;
  final String location;
  final TextStyle? locationTextStyle;
  final Icon? locationIcon;
  final Icon? durationIcon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                duration,
                style: durationTextStyle ??
                    theme.textTheme.bodyText2!.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 5),
              const Icon(
                Icons.access_time,
                color: Color(0xFF000000),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                location,
                style: locationTextStyle ??
                    theme.textTheme.bodyText2!.copyWith(color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              const Icon(
                Icons.location_on,
                color: Color(0xFF000000),
                size: 18,
              ),
            ],
          )
        ],
      ),
    );
  }
}
