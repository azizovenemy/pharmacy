import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final double starSize;
  final TextStyle? textStyle;

  const RatingWidget({
    super.key,
    required this.rating,
    this.starSize = 24.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (index) => Icon(
              index < rating.floor() ? Icons.star : Icons.star_border,
              size: starSize,
              color: Colors.amber,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          rating.toString(),
          style: textStyle,
        ),
      ],
    );
  }
}
