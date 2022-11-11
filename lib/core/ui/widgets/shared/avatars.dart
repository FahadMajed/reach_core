import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class Avatar extends StatelessWidget {
  final String link;
  final double dimension;
  final Color loadingColor;
  const Avatar({Key? key, required this.link, this.dimension = 96, this.loadingColor = Colors.white}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dimension,
      height: dimension,
      child: Align(
        widthFactor: 1,
        heightFactor: 1,
        child: Padding(
          padding: const EdgeInsets.only(),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 0.5,
                color: Colors.grey[500]!,
              ),
            ),
            child: ClipOval(
              child: Image(
                image: NetworkImage(link),
                errorBuilder: (_, __, ___) => const EmptyAvatar(),
                loadingBuilder: (_, child, event) {
                  if (event == null) {
                    return child;
                  } else {
                    return Loading(
                        color: loadingColor,
                        value: event.expectedTotalBytes != null
                            ? (event.cumulativeBytesLoaded / event.expectedTotalBytes!.toDouble())
                            : null);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyAvatar extends StatelessWidget {
  final double iconSize;
  final Color color;

  const EmptyAvatar({
    Key? key,
    this.iconSize = 96,
    this.color = Colors.black54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(width: 0.1, color: darkBlue700),
            borderRadius: const BorderRadius.all(Radius.circular(60))),
        child: Icon(
          Icons.person_rounded,
          size: iconSize,
          color: color,
        ),
      ),
    );
  }
}

class AvatarWithName extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int? color;
  final Widget subtitle;

  const AvatarWithName({
    Key? key,
    required this.imageUrl,
    required this.title,
    this.color,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (imageUrl.isEmpty)
          LetterAvatar(
            dimension: 42,
            title: title,
            color: color ?? Colors.grey[200]!.value,
          )
        else
          Avatar(
            dimension: 42,
            link: imageUrl,
          ),
        sizedWidth8,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: descMed,
            ),
            subtitle
          ],
        ),
      ],
    );
  }
}
