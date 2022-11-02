// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class StarClipper extends CustomClipper<Path> {
//   StarClipper(this.numberOfPoints);

//   /// The number of points of the star
//   final int numberOfPoints;

//   @override
//   Path getClip(Size size) {
//     double width = size.width;
//     print(width);
//     double halfWidth = width / 2;

//     double bigRadius = halfWidth;

//     double radius = halfWidth / 1.3;

//     double degreesPerStep = _degToRad(360 / numberOfPoints);

//     double halfDegreesPerStep = degreesPerStep / 2;

//     var path = Path();

//     double max = 2 * math.pi;

//     path.moveTo(width, halfWidth);

//     for (double step = 0; step < max; step += degreesPerStep) {
//       path.lineTo(halfWidth + bigRadius * math.cos(step),
//           halfWidth + bigRadius * math.sin(step));
//       path.lineTo(halfWidth + radius * math.cos(step + halfDegreesPerStep),
//           halfWidth + radius * math.sin(step + halfDegreesPerStep));
//     }

//     path.close();
//     return path;
//   }

//   num _degToRad(num deg) => deg * (math.pi / 180.0);

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     StarClipper oldie = oldClipper as StarClipper;
//     return numberOfPoints != oldie.numberOfPoints;
//   }
// }

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               height: 200,
//               width: 200,
//               child: ClipPath(
//                 clipper: StarClipper(14),
//                 child: Container(
//                   height: 150,
//                   color: Colors.green[500],
//                   child: Center(
//                       child: Text(
//                     "+6",
//                     style: TextStyle(fontSize: 50),
//                   )),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
