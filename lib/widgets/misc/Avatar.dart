import 'package:flutter/material.dart';
import 'package:gobz_app/mixins/DisplayableAvatar.dart';

class Avatar extends StatelessWidget {
  final DisplayableAvatar avatar;
  final double size;

  const Avatar(this.avatar, {Key? key, this.size = 25}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (avatar.avatarImageUrl != null) {
      return CircleAvatar(
        radius: size,
        backgroundImage: NetworkImage(avatar.avatarImageUrl!),
      );
    } else {
      return CircleAvatar(
        radius: size,
        child: Text(avatar.avatarText[0].toUpperCase()),
      );
    }
  }
}
