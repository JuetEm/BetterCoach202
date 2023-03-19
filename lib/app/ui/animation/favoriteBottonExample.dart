import 'package:flutter/widgets.dart';
import 'package:favorite_button/favorite_button.dart';

class FavoriteButtonExample extends StatefulWidget {
  const FavoriteButtonExample({super.key});

  @override
  State<FavoriteButtonExample> createState() => _FavoriteButtonExampleState();
}

class _FavoriteButtonExampleState extends State<FavoriteButtonExample> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StarButton(
            valueChanged: (_isFavorite) {
              print('Is Favorite $_isFavorite)');
            },
          )
    );
  }
}