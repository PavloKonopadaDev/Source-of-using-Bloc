import 'package:proximacrm/values/dimens.dart';
import 'package:flutter/material.dart';

class CLMItemView extends StatelessWidget {
  static const double _IMAGE_HEIGHT_SIZE = 76;
  static const int _MAX_TITLE_LINES = 2;

  final String title;
  final Widget image;
  final Function()? onSelect;

  CLMItemView(this.title, {
    required this.image,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) => Material(child: InkWell(
    onTap: onSelect,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: _IMAGE_HEIGHT_SIZE, child: image),
        Padding(
          padding: const EdgeInsets.all(ThemeDimens.spaceNormal),
          child: Text(title,
            style: Theme.of(context).textTheme.subtitle1,
            maxLines: _MAX_TITLE_LINES,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  ));
}