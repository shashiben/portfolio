import 'package:flutter/material.dart';

class LocationDateWidget extends StatelessWidget {
  LocationDateWidget({
    @required this.duration,
    @required this.location,
    this.durationIcon,
    this.locationIcon,
    this.locationTextStyle,
    this.durationTextStyle,
  });

  final String duration;
  final TextStyle durationTextStyle;
  final String location;
  final TextStyle locationTextStyle;
  final Icon locationIcon;
  final Icon durationIcon;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                duration,
                style: durationTextStyle ??
                    theme.textTheme.bodyText2.copyWith(color: Colors.black),
              ),
              SizedBox(height: 5),
              Icon(
                    Icons.access_time,
                    color: Color(0xFF000000),
                    size: 18,
                  ) ??
                  durationIcon,
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                location,
                style: locationTextStyle ??
                    theme.textTheme.bodyText2.copyWith(color: Colors.black),
              ),
              SizedBox(
                height: 5,
              ),
              Icon(
                    Icons.location_on,
                    color: Color(0xFF000000),
                    size: 18,
                  ) ??
                  locationIcon,
            ],
          )
        ],
      ),
    );
  }
}
