import 'package:flutter/material.dart';
import 'package:gobz_app/data/mixins/DisplayableAvatar.dart';
import 'package:gobz_app/view/widgets/generic/Avatar.dart';

class AvatarRow extends StatelessWidget {
  final List<DisplayableAvatar> avatars;
  final double avatarsSize;
  final int maxDisplayAmount;
  final MainAxisAlignment mainAxisAlignment;

  const AvatarRow({
    Key? key,
    required this.avatars,
    this.avatarsSize = 25,
    required this.maxDisplayAmount,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);

  List<Widget> _computeChildren(BuildContext context) {
    if (avatars.isEmpty) {
      return [];
    }

    if (avatars.length <= maxDisplayAmount) {
      return avatars
          .map((avatar) => Avatar(
                avatar,
                size: avatarsSize,
              ))
          .toList();
    }

    final List<Widget> children = <Widget>[];

    final List<Widget> avatarWidgets = avatars
        .take(maxDisplayAmount)
        .map((avatar) => Avatar(
              avatar,
              size: avatarsSize,
            ))
        .toList();

    final Widget counter = Padding(
      padding: EdgeInsets.only(left: 4),
      child: Text(
        "+${avatars.length - maxDisplayAmount}",
      ),
    );

    children.addAll(avatarWidgets);
    children.add(counter);

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: _computeChildren(context),
    );
  }
}
