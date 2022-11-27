import 'package:flutter/widgets.dart';

class LocationAdd extends StatefulWidget {
  const LocationAdd({super.key});

  @override
  State<LocationAdd> createState() => _LocationAddState();
}

class _LocationAddState extends State<LocationAdd> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text("시 도")
          ,Text("군 구")
          ,Text("읍 면 동")
        ],
      ),
    );
  }
}