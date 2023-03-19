import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';

class LikeButtonExample extends StatefulWidget {
  final bool isFavorite;
  final double size;
  final onTap;
  const LikeButtonExample({required this.isFavorite, required this.size, required this.onTap, super.key});

  @override
  State<LikeButtonExample> createState() => _LikeButtonExampleState();
}

class _LikeButtonExampleState extends State<LikeButtonExample> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LikeButton(
        size: widget.size,
        likeBuilder: (isTapped) {
          return // Icon(Icons.bookmark ); 
          SvgPicture.asset(
            widget.isFavorite //svg파일이 firebase에서 안보이는 경우
                //https://stackoverflow.com/questions/72604523/flutter-web-svg-image-will-not-be-displayed-after-firebase-hosting
                ? "assets/icons/favoriteSelected.svg"
                : "assets/icons/favoriteUnselected.svg",
          );
        },
        onTap: (isLiked) async {
          widget.onTap();
          return true;
        },
      ),
    );
  }
}
