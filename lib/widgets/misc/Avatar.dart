import 'package:flutter/material.dart';
import 'package:gobz_app/models/User.dart';

class Avatar extends StatelessWidget {
  final User user;
  final double size;

  const Avatar(this.user, {Key? key, this.size = 25}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user.imageUrl != null) {
      return CircleAvatar(
        radius: size,
        backgroundImage: NetworkImage(user.imageUrl!),
      );
    } else {
      return CircleAvatar(
        radius: size,
        child: Text(user.name[0].toUpperCase()),
      );
    }
  }
}
